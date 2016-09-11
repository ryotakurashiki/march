class DeactiveConcert < ApplicationRecord
  has_many :appearance_artists, as: :attachable
  has_many :artists, through: :appearance_artists

  def eplus_url
    "http://eplus.jp/sys/" + eplus_id
  end

  def self.find_or_create_by(params)
  	self.find_by(title: params[:title], date_text: params[:date_text], place: params[:place]) || self.create(params)
  end
end
