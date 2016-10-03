class UserConcertJoining < ApplicationRecord
  after_create :create_watched_artists, unless: :fes?

  belongs_to :user
  belongs_to :concert
  has_many :watched_artists, dependent: :destroy
  accepts_nested_attributes_for :watched_artists

  def create_watched_artists
    concert.appearance_artists.each do |appearance_artist|
      watched_artists.create(appearance_artist_id: appearance_artist.id)
    end
  end

  def fes?
    concert.fes?
  end
end
