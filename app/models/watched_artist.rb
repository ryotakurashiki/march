class WatchedArtist < ApplicationRecord
  belongs_to :appearance_artist
  belongs_to :user_concert_joining
end
