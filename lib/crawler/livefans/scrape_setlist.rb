require 'phantomjs'

module Crawler::Livefans
  class ScrapeSetlist < Crawler::MechanizeBase
    def initialize
      super
      @base_url = 'http://www.livefans.jp'
    end

    def run
      MediumArtistRelation.livefans.crawlable(3).each do |medium_artist_relation| #.reverse
      #MediumArtistRelation.where(medium_artist_id: ["70887", "100"], medium_id: 3).each do |medium_artist_relation|
        ActiveRecord::Base.connection_pool.with_connection do
          setlist_array = []
          setlists = []
          artist = medium_artist_relation.artist
          crawl_status = medium_artist_relation.crawl_status

          url = medium_artist_relation.livefans_url
          puts "次のアーティスト #{artist.name}"

          while true
            puts "↓次見に行くページ↓"
            puts url
            @logger.info "visit #{url}"

            sleep(3)
            # フェスかどうか見ておく
            page = @agent.get(url)

            #セトリURL（出演情報)の取得
            elements = page.search('//*[@id="schBox"]/div')
            elements.each do |element|
              if element.get_attribute(:class)
                a = element.at('h3 a').get_attribute(:href)
                fes_flag = element.get_attribute(:class).match(/fes/)? 1 : nil
                setlist_array << [a, fes_flag] if a.match(/event/)
              end
            end

            ## 既に1度スクレピング済みで最後の終演が1週間以上前（新規公演の追加ないだろうと判断）の場合はページめくり終了 ##
            break if setlist_array.empty?
            appearance_artists = AppearanceArtist.where(setlist_path: setlist_array.last[0], artist_id: artist.id)
            if appearance_artists.present?
              if appearance_artists.first.attachable
                if appearance_artists.first.attachable.close?(7)
                  puts "stop pagination"
                  break
                end
              end
            end

            nolinkflag = 1
            page.search('//*[@id="schBox"]/p[@class="pageNate"]/span[@class="next"]/a').each do |a|
              nolinkflag = 0
              url = @base_url + a.get_attribute(:href)
            end
            if nolinkflag == 1 then
              break
            end
            #break
          end # アーティストの出演情報終了

          setlist_array.each do |setlist_component|
            setlist_path = setlist_component[0]
            fes_flag = setlist_component[1]
            appearance_artists = AppearanceArtist.where(setlist_path: setlist_path, artist_id: artist.id)

            #### 存在していて終演している場合はスキップ ###
            if appearance_artists.present?
              if appearance_artists.first.attachable
                if appearance_artists.first.attachable.close?
                  puts "this setlist have already been scraped and concert closed"
                  next
                end
              end
            end

            #if setlist doesn't exit. setlist = appearance_artist
            puts ""
            url = @base_url + setlist_path
            sleep(2.5)
            page = @agent.get(url)
            puts setlist_path

            ###### どんなページかで場合分け必要? ######

            ##### 普通にセトリページの場合 #####
            puts a_livename = page.at('//*[@id="content"]/div/div/div/h3[@class="liveName"]/a')
            a_livename = page.at('//*[@id="content"]/div/div/div/h3[@class="liveName2"]/a') unless a_livename
            livefans_path = a_livename.get_attribute(:href)
            concert_title = a_livename.inner_text
            date_text = page.at('//*[@id="content"]/div/div/div/p[@class="date"]').inner_text

            ## appearance_artistの有無で場合分け
            if appearance_artists.present? # 1回以上スクレピングしたことある場合
              puts "this setlist have been scraped once"
              if appearance_artists.first.not_decided
                puts "appearance date have not been decided yet"
                puts date_text = page.at('//*[@id="content"]/div/div/div/p[@class="date"]').inner_text
                date_decided(appearance_artists, Date.parse(date_text)) if date_text != "出演日未定"
                # 出演日未定がありえるフェスの場合は、livefans_url変わらないのでそこの処理入れない #
              else
                # concertが変わっている場合は更新 / appearance_artistが存在する時concertも存在
                #appearance_artists.first.attachable.update(livefans_path: livefans_path)
                appearance_artists.first.attachable.update(livefans_path: livefans_path)
              end

            else # 初めてのスクレピング→appearance_artistが存在しない → どのコンサートに紐付けていくか
              puts "new setlist"
              # 出演日決まってるか、コンサート存在するか、複数アーティスト出演かどうか
              if livefans_path.match(/group/)
                puts "this page has group link"
                date = Date.parse(date_text)
                concerts = Concert.where(livefans_path: livefans_path, date: date)
              else
                puts "this page has event link"
                concerts = Concert.where(livefans_path: livefans_path)
              end

              unless concerts.present? # live_fansと紐付いたコンサートが存在しない場合 → コンサートを作成
                puts "new concert"
                concerts = create_concerts(livefans_path, concert_title, date_text, page, artist)
              end
              if date_text == "出演日未定"# 出演日決まってない → not_decidedで全部にappearance_artistを作成
                puts "appearance date have not been decided yet"
                if concerts.present?
                  concerts.each do |concert|
                    delete_eplus_concert(concert, artist)
                    concert.appearance_artists.find_or_create_by(artist_id: artist.id).
                    update(not_decided: true, setlist_path: setlist_path)
                  end
                end
              else # 出演日決まっている → 決まっている日に作成
                date = Date.parse(date_text)
                # 出演予定を追加
                if concerts.present?
                  puts "create new appearance_artist"
                  concert = concerts.find_by(date: date)
                  delete_eplus_concert(concert, artist)
                  concert.appearance_artists.
                  find_or_create_by(artist_id: artist.id).update(setlist_path: setlist_path)
                end
              end
            end
          end
        end
      end
    end

    private

    def date_decided(appearance_artists, date)
      concerts = appearance_artists.map{ |a| a.concert }
      concert.each do |concert|
        if concert.date = date
          concert.appearance_artist.update(not_decided: false)
        else
          concert.appearance_artist.destroy
        end
      end
    end

    def delete_eplus_concert(concert, artist)
      # eplus_concertが存在すれば、今見ているappearance_artistを削除
      eplus_concert = artist.concerts.where.not(eplus_id: nil).find_by(date: concert.date, livefans_path: nil)
      if eplus_concert.present?
        puts "delete eplus concert appearance_artist"
        eplus_concert.appearance_artists.find_by(artist_id: artist.id).destroy
        # appearance_artistがnilになったらeplus_concertを消す
        eplus_concert.destroy if eplus_concert.appearance_artists.empty?
      end
    end

    def create_concerts(livefans_path, concert_title, date_text, page, artist)
      if page.at('//*[@id="content"]/div/div/div/p[@class="parentNavi"]/a') ## 複数アーティストの場合
        sleep(2)
        page2 = @agent.get(@base_url+livefans_path)
        h2_date_text = page2.at('//*[@id="container"]/div[@class="col"]/h2[@class="date"]').inner_text
        place_text = h2_date_text
        date_text = h2_date_text.gsub(/＠(.*)/,"")
        if date_text.include?("～") #複数日
          dates = date_text.split("～")
          dates.map!{|date| Date.parse(date)}

          puts dates
          # 3daysの場合の対応
          date_last_a_day_before = dates[0]
          date_last = dates[1]
          while (date_last_a_day_before + 1) != date_last
            date_last_a_day_before += 1
            dates << date_last_a_day_before
          end
        else
          dates = [Date.parse(date_text)]
        end
      else # ワンマン
        dates = [Date.parse(date_text)]
        place_text = page.at('//*[@id="content"]/div/div/div/address').inner_text
      end
      place_text = place_text.match(/＠(.*)/)[1]

      foreign_concert = !place_text.match(/\(.*(都|道|府|県)\)$/)
      if foreign_concert
        puts "foreign_concert"
        place = place_text.gsub(/\((.*)\)$/, "")
        country_name = place_text.match(/\((.*)\)$/)[1]
        prefecture = Prefecture.find_or_create_by(name: country_name)
        prefecture.update(area: "海外")
        prefecture_id = prefecture.id
      else
        place = place_text.gsub(/\((.{2}|.{3}|.{4})\)$/, "")
        prefecture_name = place_text.match(/\((.{2}|.{3}|.{4})\)$/)[1].gsub(/(都|府|県)$/, "")
        prefecture_id = Prefecture.find_by_name(prefecture_name).id
      end

      title_edited = concert_title.present? ? true : false
      livefans_path = nil if livefans_path == "/groups/0"
      # 複数コンサートをcreate
      dates.each do |date|
        # livefans_pathは存在しないが
        concert = artist.concerts.where.not(eplus_id: nil).find_by(date: date)
        if concert.present? # e+側でconcertは存在する → livefansの情報で上書き
          puts "updated eplus concert #{date} : #{concert_title}"
          concert.update(title: concert_title, livefans_path: livefans_path,
           place: place, prefecture_id: prefecture_id, date: date, title_edited: title_edited)
        else # # e+側でもconcertは存在しない → 普通にcreate
          unless Concert.find_by(place: place, date: date)
            puts "created concert #{date} : #{concert_title}"
            Concert.create(title: concert_title, livefans_path: livefans_path,
             place: place, prefecture_id: prefecture_id, date: date, title_edited: title_edited)
          end
        end
      end
      Concert.where(livefans_path: livefans_path,date: dates)
    end

  end
end