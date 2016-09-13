namespace :eplus_crawler do
  desc "e+関連アーティストのクロール"
  task :artist_relations => :environment do
    Crawler::Eplus::ScrapeArtistRelation.new.run
  end

  desc "e+関連アーティストのクロール"
  task :concerts => :environment do
    Crawler::Eplus::ScrapeConcert.new.run
  end
end
