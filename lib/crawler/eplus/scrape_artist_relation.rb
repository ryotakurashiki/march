require 'phantomjs'
require 'csv'

module Crawler::Eplus
  class ScrapeArtistRelation < Crawler::CapybaraBase
    def run
      #artists = Artist.artist_relations_nil
      artists = Artist.artist_relations_small(10)
      puts artists.size
      Parallel.each(artists.shuffle, in_threads: 3) do |artist|
        ActiveRecord::Base.connection_pool.with_connection do
          session = create_session

          puts "↓次見に行くページ↓"
          puts url = artist.eplus_url
          @logger.info "visit #{url}"

          begin
            sleep(1)
            session.visit url
            puts "ステータスコード #{session.status_code}"
          rescue
            puts "Can't loading the page"
            @logger.error "Can't loading the page : #{$!}"
            session.driver.quit
            next
          end

          while true
            break if session.all("#box_related_word").count >= 1 || js_finish?(session)
            puts "wait for #box_related_word table"
            sleep(2)
          end

          words_count = session.all("#box_related_word li").count
          puts "関連アーティスト数 #{words_count}"

          # 関連アーティストのもっと見るをクリック
          while true
            begin
              puts "もっと見る1回押すで"
              session.find('a#display_relativity_word_quantity_anchor').click
              while true
                # 表示が増えるかajaxが終わったら進む
                if session.all("#box_related_word li").count > words_count || js_finish?(session)
                  words_count = session.all("#box_related_word li").count
                  break
                end
                puts "wait for #box_related_word ajax"
                sleep(2)
              end
              puts "関連アーティスト数 #{words_count}"
              break if words_count > 10
            rescue
              puts "これ以上もっと見れない"
              break
            end
          end

          begin
            puts "関連アーティストのスクレイピング"
            doc = Nokogiri::HTML.parse(session.html)
            artist_relation_list =  doc.css('#relativityWordUnorderedList li')
            artist_relation_list.each do |element|
              puts related_eplus_artist_id = element.css('a.favorite').first[:id].match(/0*([1-9][0-9]*)/)[1]
              relation = MediumArtistRelation.find_by(medium_id: 1, medium_artist_id: related_eplus_artist_id)
              artist.artist_relations.find_or_create_by(related_artist_id: relation.try(:artist_id), related_eplus_artist_id: related_eplus_artist_id)
            end
            @logger.info "ralated_artist scraping success at #{url}"
          rescue
            @logger.warn "ralated_artist scraping error at #{url}"
          end
          session.driver.quit
        end
      end
    end

	end
end
