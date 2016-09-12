class Artist < ApplicationRecord
  has_many :appearance_artists
  has_many :concerts, through: :appearance_artists
  has_many :artist_relations
  has_many :medium_artist_relations
  has_many :media, through: :medium_artist_relations
  has_many :favorite_artists
  has_many :users, through: :favorite_artists

  def self.find_or_create_by(params)
  	self.find_by(name: params[:name]) || self.create(params)
  end
end
