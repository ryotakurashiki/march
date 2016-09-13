require 'phantomjs'
require 'csv'

module Crawler
  class Base
    def initialize
      @logger = Logger.new(Rails.root.join('log', 'crawler.log'))
      @logger.level = Logger::INFO
      @logger.warn "=> Booting EplusCrawler..."
      set_capybara()
    end

    protected

    def create_session
      session = Capybara::Session.new(:poltergeist)
      session.driver.headers = {
        'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36"
      }
      session
    end

    private

    def set_capybara
  	  Capybara.register_driver :poltergeist do |app|
  	    options = {
  	      :phantomjs => Phantomjs.path, :js_errors => false, :timeout => 60000,
  	      phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=any']
  	    }
  	    Capybara::Poltergeist::Driver.new(app, options)
      end
	  end

	end
=begin
  class Eplus# < Base
    def artist_relations
      Artist.artist_relations_nil.each do |artist|
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
            break if session.all("#box_related_word").count >= 1 || session.evaluate_script('jQuery.active').zero?
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
                if session.all("#box_related_word li").count > words_count || session.evaluate_script('jQuery.active').zero?
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
          session.driver.quit
        end
      end
    end
  end
=end
end