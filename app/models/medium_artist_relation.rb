class MediumArtistRelation < ApplicationRecord
  belongs_to :artist, optional: true
  belongs_to :medium

  after_create :create_crawl_status
  has_one :crawl_status, dependent: :destroy

  scope :eplus, -> { where(medium_id: 1) }
  scope :camp, -> { where(medium_id: 2) }
  scope :livefans, -> { where(medium_id: 3) }
  scope :crawlable, -> (period) {
    joins(:crawl_status).
    where("crawl_statuses.crawled_on IS NULL OR crawl_statuses.crawled_on < ?", period.days.ago)
  }

  def eplus_url
  	"https://eplus.jp/ath/word/" + medium_artist_id
  end

  def livefans_url
    "http://www.livefans.jp/search/artist/#{medium_artist_id}?setlist=0&year=&sort=e1"
  end

end
