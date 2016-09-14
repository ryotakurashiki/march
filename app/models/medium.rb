class Medium < ApplicationRecord
  has_many :medium_artsit_relations
  has_many :artists, through: :medium_artsit_relations

  def self.find_or_create_by(params)
    medium = self.find_by(id: params[:id])
    medium.present? ? medium.update(params) : self.create(params)
  end
end
