class MediumArtistRelation < ApplicationRecord
  belongs_to :artist, optional: true
  belongs_to :medium

  after_create :create_crawl_status
  has_one :crawl_status, dependent: :destroy

  scope :eplus, -> { where(id: 1) }
  scope :camp, -> { where(id: 2) }

  def eplus_url
  	"https://eplus.jp/ath/word/" + medium_artist_id
  end
end
