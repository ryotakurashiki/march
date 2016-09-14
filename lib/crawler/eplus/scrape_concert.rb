require 'phantomjs'
require 'csv'

module Crawler::Eplus
  class ScrapeConcert < Crawler::Base
    def run
      Parallel.each(MediumArtistRelation.eplus.crawlable(3), in_threads: 3) do |medium_artist_relation|
      #MediumArtistRelation.eplus.crawlble(3).each do |medium_artist_relation|
        ActiveRecord::Base.connection_pool.with_connection do
          artist = medium_artist_relation.artist
          crawl_status = medium_artist_relation.crawl_status
          session = create_session
          puts "↓次見に行くページ↓"
          puts url = medium_artist_relation.eplus_url
          @logger.info "visit #{url}"

          begin
            sleep(1)
            session.visit url
            puts "ステータスコード #{session.status_code}"
          rescue
            puts "Can't loading the page"
            @logger.error "Can't loading the page : #{$!}"
            crawl_status.error_count += 1
            crawl_status.save
            session.driver.quit
            next
          end

          while true
            break if session.all("#performance_info .cmf_torutsume_component").count >= 1 || js_finish?(session)
            puts "wait for #performance_info"
            sleep(2)
          end

          if Nokogiri::HTML.parse(session.html).at("#performance_list").attr("style").match(/none/)
            puts "公演なし"
            crawl_status.update(crawled_on: Time.zone.now)
            session.driver.quit
            next
          end

          concerts_count = session.all("#performanceUnorderedList li").count
          puts "公演数 #{concerts_count}"

          # 公演情報のもっと見るをクリック
          while true
            begin
              puts "もっと見る1回押すで"
              session.find('a#display_performance_quantity_anchor').click
              while true
                # 表示が増えるかajaxが終わったら進む
                if session.all("#performanceUnorderedList li").count > concerts_count || js_finish?(session)
                  concerts_count = session.all("#performanceUnorderedList li").count
                  break
                end
                puts "wait for #performanceUnorderedList ajax"
                sleep(2)
              end
              puts "公演数 #{concerts_count}"
            rescue
              puts "これ以上もっと見れない"
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
              puts self_planed = artist.name == title
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
                puts "eplus_artist_name: #{artist.name}"
                puts "title: #{title}"
                if dates.length == 2 && dates[1] - 1 == dates[0] && artist.name == title
                  #create.hogehoge
                  puts "連続2daysかつ公演名とアーティスト名が一致"
                  concerts = []
                  dates.each do |date|
                    concert = Concert.find_or_create_by(
                      title: title, place: place, prefecture_id: Prefecture.find_by_name(prefecture).id,
                      date: date, eplus_id: eplus_id, self_planed: self_planed
                    )
                    concert.appearance_artists.find_or_create_by(artist_id: artist.id) if concert
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
                concert.appearance_artists.find_or_create_by(artist_id: artist.id) if concert
              end
              puts ""
            end
          rescue
            puts "スクレイピングでエラー"
            @logger.warn "scraping error : #{$!}"
            crawl_status.update(crawled_on: Time.zone.now)
            next
          end
          crawl_status.update(crawled_on: Time.zone.now)
          session.driver.quit
        end
      end
    end
	end
end
