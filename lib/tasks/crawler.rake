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

namespace :livefans_crawler do
  desc "セットリストの取得:プロキシ利用"
  task :setlists => :environment do
    Crawler::Livefans::ScrapeSetlist.new.run
  end

  desc "セットリストの取得:プロキシ利用しない"
  task :setlists_proxy_false => :environment do
    Crawler::Livefans::ScrapeSetlist.new(false).run
  end
end

namespace :camp_crawler do
  desc "チケットの取得"
  task :tickets => :environment do
    Crawler::Camp::ScrapeTicket.new.run
  end
end
