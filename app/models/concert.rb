class Concert < ApplicationRecord
  has_many :appearance_artists, as: :attachable, dependent: :delete_all
  accepts_nested_attributes_for :appearance_artists
  has_many :artists, through: :appearance_artists
  belongs_to :prefecture
  has_many :user_concert_joinings
  has_many :users, through: :user_concert_joinings
  has_many :tickets

  scope :close, -> (days = 0) { where(arel_table[:date].lt(days.days.ago)) }
  scope :open, -> (days = 0) { where(arel_table[:date].gteq(Date.today)) }

  def close?(days = 0)
    date < days.days.ago
  end

  def self.find_or_create_by(params)
    #self.find_by(title: params[:title], date: params[:date], place: params[:place]) || self.create(params)

    if concert = self.find_by(date: params[:date], place: params[:place])
      # e+IDが変わっただけなのに更新されるのを防ぐ、一方で日付と場所だけだと同日同会場の更新ができない
      unless concert.eplus_id == params[:eplus_id]
        DeactiveConcert.create(params).update(eplus_id_edited: true)
      end
      nil
    else
      self.create(params)
    end
  end
end
