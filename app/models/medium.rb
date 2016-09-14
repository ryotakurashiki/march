class Medium < ApplicationRecord
  has_many :medium_artsit_relations
  has_many :artists, through: :medium_artsit_relations
end
