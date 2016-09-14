require 'phantomjs'
require 'csv'

namespace :initial do

  desc "都道府県の登録"
  task :prefectures => :environment do
    CSV.foreach("#{Rails.public_path}/csv/prefectures.csv") do |row|
      Prefecture.create(name: row[0], area: row[1])
    end
  end

  desc "CSVから最初のアーティストデータ登録"
  task :artist_data => :environment do
    eplus = Medium.find_or_create_by(id: 1, name: "e+", en_name: "eplus")
    camp = Medium.find_or_create_by(id: 2, name: "チケットキャンプ", en_name: "camp")
    csv = CSV.read("#{Rails.public_path}/csv/initial_artists.csv", headers: false)
    #0:eplus_artist_id 1:artist.name 2:camp_artist_name 3:camp_artist_id 4:subcategory 5:unused 6:category
    csv.each do |row|
      eplus_artist_id = row[0]
      artist_name = row[1]
      camp_artist_id = row[3]
      artist_category = row[6]
      if eplus_artist_id
        artist = Artist.find_or_create_by(name: artist_name, category: artist_category)
        artist.medium_artist_relations.find_or_create_by(medium_id: eplus.id).update(medium_artist_id: eplus_artist_id)
        artist.medium_artist_relations.find_or_create_by(medium_id: camp.id).update(medium_artist_id: camp_artist_id)
      else
        unless relation = MediumArtistRelation.find_by(medium_id: camp.id, medium_artist_id: camp_artist_id)
          MediumArtistRelation.create(medium_id: camp.id, medium_artist_id: camp_artist_id)
        end
      end
    end
  end

  desc "最初のe+アーティスト取得"
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

    eplus_artist_ids = CSV.read('#{Rails.public_path}/csv/initial_eplus_artist_ids.csv', headers: false).map {|row| row[0].to_s}
    puts eplus_artist_ids.size
    puts eplus_artist_ids.uniq.size
    #eplus_artist_ids -= MediumArtistRelation.where(medium_id: 1).pluck("medium_artist_id")

    eplus_artist_ids -= Artist.includes(:medium_artist_relations).
    where(medium_artist_relations: {medium_id: 1}).pluck("medium_artist_id")
    puts eplus_artist_ids.size

    Parallel.each(eplus_artist_ids, in_threads: 5) do |eplus_artist_id|
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

          wait_for_element_display("#performance_info", session, url)
          doc = Nokogiri::HTML.parse(session.html)
          puts info = doc.at("#performance_list h2").inner_text

          puts "アーティストを登録"
          puts eplus_artist_name = info.match(/(.*)の公演情報/)[1]
          artist = Artist.find_or_create_by(name: eplus_artist_name)
          artist.medium_artist_relations.find_or_create_by(medium_id: 1).update(medium_artist_id: eplus_artist_id)
        rescue
          puts "アーティスト名取得でエラー"
          logger.error "Can't loading the page : #{$!}"
          session.driver.quit
          next
        end
        session.driver.quit
      end
    end
  end
end

def wait_for_element_display(element, session, url)
  i = 0
  while true
    i += 1
    if i >= 30
      session.visit url
      i = 0
    end
    break if session.all(element).count > 0
    sleep(2)
    puts "Element have not displayed"
  end
end

def wait_for_jquery(session)
  while true
    break if session.evaluate_script('jQuery.active').zero?
    puts "wait for jQuery"
    sleep(2)
  end
end