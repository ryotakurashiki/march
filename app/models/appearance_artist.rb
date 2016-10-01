class AppearanceArtist < ApplicationRecord
  after_create :update_concert_category
  after_destroy :update_concert_category

  belongs_to :attachable, polymorphic: true
  belongs_to :artist
  has_many :favorite_artists, primary_key: "artist_id", foreign_key: "artist_id"
  has_many :watched_artists

  def self.create_or_find(params)
    self.create(params) unless self.find_by()
  end

  def setlist_url
    "http://www.livefans.jp" + setlist_path
  end

  def update_concert_category
    concert = self.attachable
    if concert.appearance_artists.size >= Settings.fes_concerts_num
      concert.update(category: 1)
    else
      concert.update(category: 2)
    end
  end
end
