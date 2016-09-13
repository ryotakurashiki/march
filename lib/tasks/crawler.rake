namespace :eplus_crawler do
  desc "e+関連アーティストのクロール"
  task :artist_relations => :environment do
    Crawler::Eplus::ArtistRelation.new.run
  end
end
