require 'phantomjs'
namespace :initial do
  require 'csv'

  desc "最初のe+アーティスト登録"
  task :eplus_artists => :environment do
    logger = Logger.new(Rails.root.join('log', 'crawler.log'))
    logger.level = Logger::INFO
    logger.warn "=> Booting EplusCrawler..."
    base_url = 'https://eplus.jp/ath/word/'
    Capybara.register_driver :poltergeist do |app|
      options = {
        :phantomjs => Phantomjs.path, :js_errors => false, :timeout => 60000,
        phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=any']
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    CSV.foreach("initial_eplus_artist_ids.csv") do |row|
      eplus_artist_id = row[0]
      ActiveRecord::Base.connection_pool.with_connection do
        session = Capybara::Session.new(:poltergeist)
        session.driver.headers = {
          'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3)"
        }

        puts "↓次見に行くページ↓"
        puts url = "#{base_url}#{eplus_artist_id}"
        logger.info "visit #{base_url}#{eplus_artist_id}"

        begin
          sleep(1)
          session.visit url
          puts "ステータスコード #{session.status_code}"

          doc = Nokogiri::HTML.parse(session.html)
          puts style = doc.at("#performance_list").attr("style")
          puts info = doc.at("#performance_list h2").inner_text

          puts "アーティストを登録"
          puts eplus_artist_name = info.match(/(.*)の公演情報/)[1]
          artist = Artist.find_or_create_by(name: eplus_artist_name)
          artist.medium_artist_relations.find_or_create_by(medium_id: 1).update(medium_artist_id: eplus_artist_id)
        rescue
          puts "アーティスト名取得でエラー"
          logger.error "Can't loading the page : #{$!}"
          next
        end
      end
    end
  end

  desc "関連e+アーティスト取得"
  task :eplus_artist_relations => :environment do
    logger = Logger.new(Rails.root.join('log', 'crawler.log'))
    logger.level = Logger::INFO
    logger.warn "=> Booting EplusCrawler..."
    base_url = 'https://eplus.jp/ath/word/'
    Capybara.register_driver :poltergeist do |app|
      options = {
        :phantomjs => Phantomjs.path, :js_errors => false, :timeout => 60000,
        phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=any']
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    Artist.all.each do |artist|
      ActiveRecord::Base.connection_pool.with_connection do
        session = Capybara::Session.new(:poltergeist)
        session.driver.headers = {
          'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3)"
        }

        puts "↓次見に行くページ↓"
        puts url = artist.eplus_url
        logger.info "visit #{base_url}#{eplus_artist_id}"

        begin
          sleep(1)
          session.visit url
          puts "ステータスコード #{session.status_code}"

          doc = Nokogiri::HTML.parse(session.html)
          puts style = doc.at("#performance_list").attr("style")
          puts info = doc.at("#performance_list h2").inner_text

          puts "アーティストを登録"
          puts eplus_artist_name = info.match(/(.*)の公演情報/)[1]
          artist = Artist.find_or_create_by(name: eplus_artist_name)
          artist.medium_artist_relations.find_or_create_by(medium_id: 1).update(medium_artist_id: eplus_artist_id)
        rescue
          puts "アーティスト名取得でエラー"
          logger.error "Can't loading the page : #{$!}"
          next
        end

        # 関連アーティストのもっと見るをクリック
        while true
          begin
            puts session.find('a#display_relativity_word_quantity_anchor').text
            session.find('a#display_relativity_word_quantity_anchor').click
            puts "1回押した"
            sleep(0.2)
          rescue
            puts "これ以上もっと見れない"
            sleep(2)
            break
          end
        end

        puts "関連アーティストのスクレイピング"
        doc = Nokogiri::HTML.parse(session.html)
        artist_relation_list =  doc.css('#relativityWordUnorderedList li')
        artist_relation_list.each do |element|
          puts related_eplus_artist_id = element.css('a.favorite').first[:id].match(/0*([1-9][0-9]*)/)[1].to_i
          artist.artist_relations.find_or_create_by(related_eplus_artist_id: related_eplus_artist_id)
        end

      end
    end
  end
  desc "最初のデータ収集"
  task :eplus_scraping => :environment do
    logger = Logger.new(Rails.root.join('log', 'crawler.log'))
    logger.level = Logger::INFO
    logger.warn "=> Booting EplusCrawler..."
    base_url = 'https://eplus.jp/ath/word/'
    Capybara.register_driver :poltergeist do |app|
      options = {
        :phantomjs => Phantomjs.path, :js_errors => false, :timeout => 60000,
        phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=any']
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    #target1 = 'https://eplus.jp/ath/word/51952' #2回もっと見る
    #target2 = 'https://eplus.jp/ath/word/14366'
    #'https://eplus.jp/ath/word/4478' #最初から表がない
    eplus_artist_ids = [*4478..96500]
    Parallel.each(eplus_artist_ids, in_threads: 1) do |eplus_artist_id|
      ActiveRecord::Base.connection_pool.with_connection do
        session = Capybara::Session.new(:poltergeist)
        session.driver.headers = {
          'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3)"
        }

        puts "↓次見に行くページ↓"
        puts url = "#{base_url}#{eplus_artist_id}"
        logger.info "visit #{base_url}#{eplus_artist_id}"

        begin
          sleep(1)
          session.visit url
          puts "ステータスコード #{session.status_code}"

          doc = Nokogiri::HTML.parse(session.html)
          puts style = doc.at("#performance_list").attr("style")
          puts info = doc.at("#performance_list h2").inner_text
        rescue
          puts "公演あるかどうかのチェックでエラー"
          logger.error "Can't loading the page : #{$!}"
          next
        end

        #アーティストを登録するか
        if style.match(/block/)
          puts "公演あり→アーティストの登録"
          puts eplus_artist_name = info.match(/(.*)の公演情報/)[1]
          artist = Artist.find_or_create_by(name: eplus_artist_name)
          artist.medium_artist_relations.find_or_create_by(medium_id: 1).update(medium_artist_id: eplus_artist_id)
        else
          puts "公演なし→next"
          logger.info "公演なし"
          next
        end

        # 公演情報のもっと見るをクリック
        while true
          begin
            puts session.find('a#display_performance_quantity_anchor').text
            session.find('a#display_performance_quantity_anchor').click
            puts "1回押した"
            sleep(0.2)
          rescue
            puts "これ以上もっと見れない"
            break
          end
        end

        # 関連アーティストのもっと見るをクリック
        while true
          begin
            puts session.find('a#display_relativity_word_quantity_anchor').text
            session.find('a#display_relativity_word_quantity_anchor').click
            puts "1回押した"
            sleep(0.2)
          rescue
            puts "これ以上もっと見れない"
            sleep(2)
            break
          end
        end

        doc = Nokogiri::HTML.parse(session.html)
        begin
          elements =  doc.css('#performanceUnorderedList li')
          elements.each do |element|
            puts element.css('a').first[:href]
            puts eplus_id = element.css('a').first[:href].match(/sys\/(.*)/)[1].gsub(/\?.*/, "")
            puts title = element.css('a h3.title').inner_text.strip
            puts place_text = element.css('a dl dd:nth-child(2)').inner_text
            puts place = place_text.gsub(/（(.{2}|.{3}|.{4})）$/, "")
            puts prefecture = place_text.match(/（(.{2}|.{3}|.{4})）$/)[1].gsub(/(都|府|県)$/, "")
            puts element.css('a dl dd.date').inner_text
            puts self_planed = eplus_artist_name == title
            date_text = element.css('a dl dd.date').inner_text

            artist_relation_list =  doc.css('#relativityWordUnorderedList li')
            artist_relation_list.each do |element|
              puts related_eplus_artist_id = element.css('a.favorite').first[:id].match(/0*([1-9][0-9]*)/)[1].to_i
              artist.artist_relations.find_or_create_by(related_eplus_artist_id: related_eplus_artist_id)
            end

            if date_text.include?("～") #複数日
              dates = date_text.split("～")
              dates.map!{|date| Date.parse(date)}
              # 連続2daysかつ公演名とアーティスト名が一致
              puts "dates_length: #{dates.length}"
              puts "date1: #{dates[1]}"
              puts "eplus_artist_name: #{eplus_artist_name}"
              puts "title: #{title}"
              if dates.length == 2 && dates[1] - 1 == dates[0] && eplus_artist_name == title
                #create.hogehoge
                puts "連続2daysかつ公演名とアーティスト名が一致"
                concerts = []
                dates.each do |date|
                  concert = Concert.find_or_create_by(
                    title: title, place: place, prefecture_id: Prefecture.find_by_name(prefecture).id,
                    date: date, eplus_id: eplus_id, self_planed: self_planed
                  )
                  concert.appearance_artists.find_or_create_by(artist_id: artist.id)
                end
              else
                # 管理画面で頑張る
                puts "管理画面で頑張る"
                deactive_concert = DeactiveConcert.find_or_create_by(
                  title: title, place: place, prefecture_id: Prefecture.find_by_name(prefecture).id,
                  date: Date.parse(date_text), eplus_id: eplus_id, self_planed: self_planed, date_text: date_text
                )
                deactive_concert.appearance_artists.find_or_create_by(artist_id: artist.id)
              end
            else
              # 普通にcreate
              puts "普通にcreate"
              concert = Concert.find_or_create_by(
                title: title, place: place, prefecture_id: Prefecture.find_by_name(prefecture).id,
                date: Date.parse(date_text), eplus_id: eplus_id, self_planed: self_planed
              )
              concert.appearance_artists.find_or_create_by(artist_id: artist.id)
            end
            puts ""
          end
        rescue
          puts "スクレイピングでエラー"
          logger.error "scraping error : #{$!}"
          next
        end
      end
    end
  end

  task :prefectures => :environment do
    CSV.foreach("public/csv/prefecture_list.csv") do |row|
      Prefecture.create(name: row[0], area: row[1])
    end
  end
end