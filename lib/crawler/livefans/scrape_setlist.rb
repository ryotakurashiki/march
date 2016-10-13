require 'phantomjs'

module Crawler::Livefans
  class ScrapeSetlist < Crawler::MechanizeBase
    def initialize(use_proxy = true)
      super
      @logger = Logger.new(Rails.root.join('log', 'mechanize.log'))
      @logger.level = Logger::INFO
      @logger.warn "=> Booting LiveFans Crawler..."
      @base_url = 'http://www.livefans.jp'
      @end_at = 1.hour.from_now
      @use_proxy = use_proxy
      @proxy_list = get_proxy_list
    end

    def run
      threads_num = @use_proxy ? 5 : 1
      medium_artist_relations = MediumArtistRelation.livefans.crawlable(3)
      Parallel.each(medium_artist_relations, in_threads: threads_num) do |medium_artist_relation|
      #medium_artist_relations.each do |medium_artist_relation| #.reverse .shuffle
      #MediumArtistRelation.where(medium_artist_id: ["70887", "100"], medium_id: 3).each do |medium_artist_relation|
        ActiveRecord::Base.connection_pool.with_connection do
          begin
            agent = create_agent
            set_proxy(agent) if @use_proxy
            setlist_array = []
            setlists = []
            artist = medium_artist_relation.artist
            crawl_status = medium_artist_relation.crawl_status
            crawl_status.update(crawled_on: Time.zone.now)
            crawl_status.error_count = 0
            crawl_status.error_message = ""
            stop_pagination = false

            url = medium_artist_relation.livefans_url
            puts "次のアーティスト #{artist.name}"
            puts "crawl_satus_id #{crawl_status.id}"

            while true
              puts "↓次見に行くページ↓"
              puts url
              @logger.info "visit #{url}"

              sleep_before_visit
              # フェスかどうか見ておく
              begin
                page = agent.get(url)
              rescue
                puts "page visitでエラ → retry"
                set_proxy(agent)
                retry
              end

              #セトリURL（出演情報)の取得
              elements = page.search('//*[@id="schBox"]/div')
              elements.each do |element|
                if element.get_attribute(:class)
                  a = element.at('h3 a').get_attribute(:href)
                  fes_flag = element.get_attribute(:class).match(/fes/)? 1 : nil
                  setlist_array << [a, fes_flag] if a.match(/event/)

                  begin
                    date_check = element.at('p[@class="date"]')
                    if date_check
                      stop_pagination = true if Date.parse(date_check.inner_text) <= Date.parse("1995/12/31")
                    end
                  rescue
                  end
                end
              end

              if stop_pagination
                puts "古すぎるのでページめくり終了"
                break
              end

              ## 既に1度スクレピング済みで最後の終演が1週間以上前（新規公演の追加ないだろうと判断）の場合はページめくり終了 ##
              break if setlist_array.empty?
              appearance_artists = AppearanceArtist.where(setlist_path: setlist_array.last[0], artist_id: artist.id)
              if appearance_artists.present? && crawl_status.crawled_on
                if appearance_artists.first.attachable
                  if appearance_artists.first.attachable.close?(7)
                    #puts "stop pagination"
                    #break
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
          rescue
            puts "scraping error"
            @logger.warn "Can't scraping : #{$!} at #{url}"
            crawl_status.error_message += ", #{$!} at #{url}"
            crawl_status.error_count = 0 if crawl_status.error_count.nil?
            crawl_status.error_count += 1
            crawl_status.save
          end

          setlist_array.each do |setlist_component|
          #Parallel.each(setlist_array, in_threads: 4) do |setlist_component|
            ActiveRecord::Base.connection_pool.with_connection do
              begin
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
                agent = create_agent
                url = @base_url + setlist_path
                sleep_before_visit
                begin
                  page = agent.get(url)
                rescue
                  puts "page visitでエラ → retry"
                  set_proxy(agent)
                  retry
                end
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
                    appearance_artists.first.attachable.update(livefans_path: livefans_path)
                  end

                else # 初めてのスクレピング→appearance_artistが存在しない → どのコンサートに紐付けていくか
                  puts "new setlist"
                  # 出演日決まってるか、コンサート存在するか、複数アーティスト出演かどうか
                  if livefans_path.match(/group/)
                    puts "this page has group link"
                    date = Date.parse(date_text)
                    if livefans_path.match(/groups\/0$/)
                      puts "groups/0"
                      concerts = []
                    else
                      concerts = Concert.where(livefans_path: livefans_path, date: date)
                    end
                  else
                    puts "this page has event link"
                    concerts = Concert.where(livefans_path: livefans_path)
                  end

                  if concerts.present? # live_fansと紐付いたコンサートが存在しない場合 → コンサートを作成
                    puts "not new concert"
                  else
                    puts "new concert"
                    concerts = create_concerts(livefans_path, concert_title, date_text, page, artist)
=begin # groupでも複数アーティスト出演の場合があるので一旦ワンマンツアー用のcreate使わない
                    unless page.at('//*[@id="content"]/div/div/div/p[@class="parentNavi"]/a') || livefans_path.match(/event|groups\/0$/)
                      puts "one man tourのようだ"
                      if (Concert.find_by(livefans_path: livefans_path).nil? || date < Date.today) && date > Date.parse("2010/01/01")
                        next_flag = create_oneman_tour(livefans_path, concert_title, date_text, page, artist)
                        next if next_flag
                      end
                      concerts = create_concerts(livefans_path, concert_title, date_text, page, artist)
                    else
                      concerts = create_concerts(livefans_path, concert_title, date_text, page, artist)
                    end
=end
                  end
                  if date_text == "出演日未定"# 出演日決まってない → not_decidedで全部にappearance_artistを作成
                    puts "appearance date have not been decided yet"
                    if concerts.present?
                      concerts.each do |concert|
                        delete_existing_concert(concert, artist)
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
                      delete_existing_concert(concert, artist)
                      concert.appearance_artists.
                      find_or_create_by(artist_id: artist.id).update(setlist_path: setlist_path)
                    end
                  end
                end
              rescue
                puts "scraping error"
                @logger.warn "Can't scraping setlist : #{$!} at #{url}"
                crawl_status.error_message += ", #{$!} at #{url}"
                crawl_status.error_count += 1
                crawl_status.save
              end
            end
          end
          if crawl_status.error_count == 0
            puts "successfly scraped #{url}"
            @logger.info "successfly scraped #{url}"
            crawl_status.update(crawled_on: Time.zone.now)
          end
          break if time_up?
        end
      end
    end

    private

    def date_decided(appearance_artists, date)
      concerts = appearance_artists.map{ |a| a.attachable }
      concerts.each do |concert|
        if concert.date = date
          concert.appearance_artist.update(not_decided: false)
        else
          concert.appearance_artist.destroy
        end
      end
    end

    def delete_existing_concert(concert, artist)
      # そのアーティストが同じ日に出演するコンサート（livefans_path: nilで見る）が存在すれば、それを消去
      # 消したコンサートのappearance_artistとuser_concert_joiningsを新しいconcertに紐付ける
      # eplusだとplaceが違えば同日同アーティストでも複数公演が作成されうる（ライブビューイングなど）ので全部消す
      existing_concerts = artist.concerts.where(date: concert.date, livefans_path: nil)
      if existing_concerts.present?
        puts "delete existing concert appearance_artist"
        # 新規作成するconcertと紐付いてる参加user, 出演artistのidを配列で取得
        user_ids = concert.users.pluck(:id)
        artist_ids = concert.artists.pluck(:id)
        existing_concerts.each do |existing_concert|
          # e+とかユーザーによって作成されたconcertを消す
          # 消すconcertに紐付いてる参加userと出演アーティストを新規作成するconcertに変更する
          existing_concert.user_concert_joinings.
            where.not(user_id: user_ids).update_all(concert_id: concert.id)
          existing_concert.appearance_artist.
            where.not(artist_id: artist_ids).update_all(concert_id: concert.id)
          existing_concert.destroy
        end
      end
    end

    def create_oneman_tour(livefans_path, concert_title, date_text, page, artist)
      if concert_title.present?
        title_edited = false
      else
        title_edited = true
        concert_title = artist.name
      end

      begin
        agent = create_agent
        sleep_before_visit
        page2 = agent.get(@base_url+livefans_path)
      rescue
        puts "page visitでエラ → retry"
        set_proxy(agent)
        retry
      end

      begin
        doc = Nokogiri::HTML.parse(page2.content.toutf8)
        rows = doc.css('div.scheduleBlock > table > tbody > tr')
        rows.each do |row|
          date_text2 = row.at('td[1]').inner_text
=begin
          place_html = row.at('td[3]').inner_html
          if place_html.match(/eventname/)
            place_text2 = place_html.match(/<span.*span><br>(.*)/)[1]
          else
            place_text2 = place_html
          end
=end
          place_text2 = row.at('td[3]').inner_text
          date2 = Date.parse(date_text2)
          foreign_concert = !place_text2.match(/\(.*(都|道|府|県)\)$/)
          if foreign_concert # ()はあるけど都道府県のいずれの文字も存在しない
            puts "foreign_concert"
            place2 = place_text2.gsub(/\((.*)\)$/, "").strip
            country_name2 = place_text2.match(/\((.*)\)$/)[1]
            prefecture2 = Prefecture.find_or_create_by(name: country_name2)
            prefecture2.update(area: "海外")
            prefecture_id2 = prefecture2.id
          elsif place_text2.match(/\(.*(都|道|府|県)\)$/)
            place2 = place_text2.gsub(/\((.{2}|.{3}|.{4})\)$/, "").strip
            prefecture_name2 = place_text2.match(/\((.{2}|.{3}|.{4})\)$/)[1].gsub(/(都|府|県)$/, "")
            prefecture_id2 = Prefecture.find_by_name(prefecture_name2).id
          else
            place2 = place_text2.strip
            prefecture_id2 = nil
          end

          concert = artist.concerts.where.not(eplus_id: nil).find_by(date: date2)
          if concert.present? # e+側でconcertは存在する → livefansの情報で上書き
            puts "updated eplus oneman tour concert #{date2} : #{concert_title}"
            concert.update(title: concert_title, livefans_path: livefans_path,
             place: place2, prefecture_id: prefecture_id2, date: date2, title_edited: title_edited)
          else # # e+側でもconcertは存在しない → 普通にcreate
            unless Concert.find_by(place: place2, date: date2)
              puts "created oneman tour concert #{date2} : #{concert_title}"
              Concert.create(title: concert_title, livefans_path: livefans_path,
                place: place2, prefecture_id: prefecture_id2, date: date2, title_edited: title_edited)
            end
          end
          concert = Concert.find_by(place: place2, date: date2)
          puts "ceate_or_find oneman tour appearance_artist"
          begin
            setlist_path2 = row.at('td.icons span.list a').get_attribute(:href)
          rescue
            puts "ワンマンツアーでsetlistがないパターン"
            next
          end
          concert.appearance_artists.
            find_or_create_by(artist_id: artist.id).update(setlist_path: setlist_path2)
        end
        # エラーがなければそのセトリのスクレピングを終了
        return true #next
      rescue
        puts "oneman tourのスクレピングでエラー"
        puts "#{$!}"
      end
    end


    def create_concerts(livefans_path, concert_title, date_text, page, artist)
      if page.at('//*[@id="content"]/div/div/div/p[@class="parentNavi"]/a') ## 複数アーティストの場合
        agent = create_agent
        sleep_before_visit
        #page2 = @agent.get(@base_url+livefans_path)
        begin
          page2 = agent.get(@base_url+livefans_path)
        rescue
          puts "page visitでエラ → retry"
          set_proxy(agent)
          retry
        end
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
      place_text = place_text.match(/＠(.*)/)[1].gsub(/出演：.*/, "")

      # ()はあるけど都道府県のいずれもないときは海外公演とみなす
      foreign_concert = !place_text.match(/\(.*(都|道|府|県)\)$/) && place_text.match(/\(.*\)$/)
      if foreign_concert
        puts "foreign_concert"
        place = place_text.gsub(/\((.*)\)$/, "").strip
        country_name = place_text.match(/\((.*)\)$/)[1]
        prefecture = Prefecture.find_or_create_by(name: country_name)
        prefecture.update(area: "海外")
        prefecture_id = prefecture.id
      elsif place_text.match(/\(.*(都|道|府|県)\)$/)
        place = place_text.gsub(/\((.{2}|.{3}|.{4})\)$/, "").strip
        prefecture_name = place_text.match(/\((.{2}|.{3}|.{4})\)$/)[1].gsub(/(都|府|県)$/, "")
        prefecture_id = Prefecture.find_by_name(prefecture_name).id
      else
        place = place_text.strip
        prefecture_id = nil
      end

      #title_edited = concert_title.present? ? true : false
      if concert_title.present?
        title_edited = false
      else
        title_edited = true
        concert_title = artist.name
      end
      #livefans_path = nil if livefans_path == "/groups/0"
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
      Concert.where(livefans_path: livefans_path,date: dates, place: place, title: concert_title)
    end

    def time_up?
      #Time.zone.now > @end_at
      false
    end

    def get_proxy_list
      proxy_list = []
      session = Crawler::CapybaraBase.new.create_session
      session.visit "http://www.cybersyndrome.net/search.cgi?q=&a=A&f=l&s=new&n=200"

      while true
        break if session.all("#div_result ul li a").count >= 1
        puts "wait for #div_result"
        sleep(2)
      end

      doc = Nokogiri::HTML.parse(session.html)
      rows = doc.css('div#div_result ul li a')
      puts rows
      rows.each do |row|
        host = row.inner_text.match(/(.*):/)[1]
        port = row.inner_text.match(/:(.*)/)[1].to_i
        proxy_list << {host: host, port: port}
      end
      puts proxy_list
      session.driver.quit
      proxy_list
    end

    def set_proxy(agent)
      proxy = @proxy_list.sample
      puts "#{proxy}を設定"
      agent.set_proxy(proxy[:host], proxy[:port])
    end

  end
end