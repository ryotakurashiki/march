class ArtistRelation < ApplicationRecord
  #belongs_to :artist
  belongs_to :artist, foreign_key: :related_artist_id
end
