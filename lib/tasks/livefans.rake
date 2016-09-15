require 'csv'

namespace :livefans do

  desc "livefansアーティスト検索"
  task :insert_initial_try => :environment do
    livefan_tests = CSV.read("#{Rails.public_path}/csv/livefans_search.csv", headers: false)
    livefan_tests.each do |row|
      #0: livefans_artist_id, 1:result_text, 2:artist_name, 3:eplus_artist_id
      params = {livefans_artist_id: row[0], result_text: row[1], artist_name: row[2], eplus_artist_id: row[3]}
      LivefanTest.create(params)
    end
  end

  desc "livefansアーティスト登録"
  task :livefans_relations => :environment do
    relations = CSV.read("#{Rails.public_path}/csv/livefans_eplus_relations.csv", headers: true)
    relations.each do |row|
      livefans_artist_id = row[0]
      eplus_artist_id = row[1]
      next if livefans_artist_id.nil?

      artist = MediumArtistRelation.find_by(medium_artist_id: eplus_artist_id, medium_id: 1).artist
      artist.medium_artist_relations.create(medium_artist_id: livefans_artist_id, medium_id: 3)
    end
  end

  desc "livefansアーティスト検索"
  task :search => :environment do
    Capybara.register_driver :poltergeist do |app|
      #Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 5000 })
      Capybara::Poltergeist::Driver.new(app, { :phantomjs => Phantomjs.path, :js_errors => false, :timeout => 5000,
      phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=any'] })
    end

    session = Capybara::Session.new(:poltergeist)
    session.driver.headers = {
        'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36"
    }

    livefan_tests = LivefanTest.where(livefans_artist_id: nil)

    livefan_tests.each do |livefan_test|
      sleep(0.2)
      begin
        puts "#{livefan_test.artist_name}を検索"

        session.visit "https://www.google.co.jp"
        keyword = livefan_test.artist_name + " livefans artist"

        session.find('div.ds input').set(keyword)
        session.find('span.lsbb input[name=btnG]').click

        doc = Nokogiri::HTML.parse(session.html)

        elements =  doc.css('#ires > ol > div > h3 > a')
        find_flag = false
        elements.each do |element|
          puts result_text = element.inner_text
          puts id = element[:href].match(/livefans.jp\/artists\/(.*)/)
          unless id.nil?
            puts id = id[1].gsub(/\&.*/, "")
            find_flag = true
            livefan_test.update(livefans_artist_id: id, result_text: result_text)
            break
          end
        end

        unless find_flag
          livefan_test.update(search_url: session.current_url)
        end
      rescue
        #livefan_test.update(search_url: session.current_url)
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