namespace :eplus_crawler do
  desc "e+関連アーティストのクロール"
  task :artist_relations => :environment do
    Crawler::Eplus.new.artist_relations
  end
end
