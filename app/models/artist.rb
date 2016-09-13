class Artist < ApplicationRecord
  has_many :appearance_artists
  has_many :concerts, through: :appearance_artists
  has_many :artist_relations
  has_many :medium_artist_relations
  has_many :media, through: :medium_artist_relations
  has_many :favorite_artists
  has_many :users, through: :favorite_artists

  scope :artist_relations_nil, -> {
    includes(:artist_relations, :medium_artist_relations).
    where(artist_relations: {related_eplus_artist_id: nil}, medium_artist_relations: {medium_id: 1})
  }

  def eplus_url
    medium_artist_relations.find_by(medium_id: 1).eplus_url
  end

  def self.find_or_create_by(params)
  	self.find_by(name: params[:name]) || self.create(params)
  end
end
