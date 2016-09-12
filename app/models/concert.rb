class Concert < ApplicationRecord
  has_many :appearance_artists, as: :attachable
  has_many :artists, through: :appearance_artists
  belongs_to :prefecture
  has_many :user_concert_joinings
  has_many :users, through: :user_concert_joinings

  def self.find_or_create_by(params)
  	self.find_by(title: params[:title], date: params[:date], place: params[:place]) || self.create(params)
  end
end
