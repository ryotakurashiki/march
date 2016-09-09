class AppearanceArtist < ApplicationRecord
  belongs_to :concert
  belongs_to :artist
end
