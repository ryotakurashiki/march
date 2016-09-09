class Concert < ApplicationRecord
  has_many :appearance_artists, as: :attachable
  has_many :artists, through: :appearance_artists
  belongs_to :prefecture

  def self.find_or_create_by(params)
  	self.find_by(title: params[:title], date: params[:date], place: params[:place]) || self.create(params)
  end
end
