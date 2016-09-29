class FavoriteArtist < ApplicationRecord
  belongs_to :artist
  belongs_to :user
  has_many :appearance_artists, primary_key: "artist_id", foreign_key: "artist_id"
end
