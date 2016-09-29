class AppearanceArtist < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  belongs_to :artist
  has_many :favorite_artists, primary_key: "artist_id", foreign_key: "artist_id"

  def self.create_or_find(params)
    self.create(params) unless self.find_by()
  end

  def setlist_url
    "http://www.livefans.jp" + setlist_path
  end
end
