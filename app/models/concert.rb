class Concert < ApplicationRecord
  has_many :appearance_artists, as: :attachable, dependent: :delete_all
  accepts_nested_attributes_for :appearance_artists
  has_many :artists, through: :appearance_artists
  belongs_to :prefecture, optional: true
  has_many :user_concert_joinings
  has_many :users, through: :user_concert_joinings
  has_many :tickets

  scope :close, -> (days = 0) { where(arel_table[:date].lt(days.days.ago.to_date)) }
  scope :open, -> (days = 0) { where(arel_table[:date].gteq(Date.today)) }
  scope :this_year, -> (year) { where(date: (Date.new(year, 1, 1))..(Date.new(year, 12, 31))) }

  def close?(days = 0)
    date < days.days.ago.to_date
  end

  def joined_by?(user)
    return false if user.nil?
    user_concert_joinings.pluck(:user_id).include?(user.id)
  end

  def livefans_url
    "http://www.livefans.jp" + livefans_path
  end

  def setlist_url
    if appearance_artists.size == 0
      return nil
    elsif appearance_artists.size == 1
      appearance_artists.first.setlist_url
    elsif !livefans_path.present?
      if appearance_artists.first.setlist_path.present?
        appearance_artists.first.setlist_url
      else
        return nil
      end
    else
      self.livefans_url
    end
  end

  def appearance_artists_filtered(user = current_user)
    #artists.includes(:favorite_artists).where(favorite_artists: {user_id: user.id}).order("favorite_artists.artist_id")
    return artists if user.nil?
    artists.find_by_sql(
      "SELECT artists.*, favorite_artists.id from artists LEFT OUTER JOIN favorite_artists
       ON favorite_artists.artist_id = artists.id AND favorite_artists.user_id = #{user.id}
       INNER JOIN appearance_artists ON artists.id = appearance_artists.artist_id
       WHERE appearance_artists.attachable_id = #{self.id} AND appearance_artists.attachable_type = 'Concert'
       ORDER BY favorite_artists.id DESC"
    )
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
