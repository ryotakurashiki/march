class Artist < ApplicationRecord
  has_many :appearance_artists
  has_many :concerts, through: :appearance_aritsts
  has_many :artist_relations
  has_many :medium_artsit_relations
  has_many :media, through: :medium_artsit_relations
end
