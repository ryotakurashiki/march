class AppearanceArtist < ApplicationRecord
  after_create :update_concert_category
  after_destroy :update_concert_category

  belongs_to :attachable, polymorphic: true
  accepts_nested_attributes_for :attachable
  belongs_to :artist
  has_many :favorite_artists, primary_key: "artist_id", foreign_key: "artist_id"
  has_many :watched_artists, dependent: :destroy

  scope :close, -> (days = 0) { where(arel_table[:date].lt(days.days.ago.to_date)) }
  scope :sorted_by_user_with_concert, -> (user, concert) {
    find_by_sql(
      "SELECT appearance_artists.* from appearance_artists
       LEFT OUTER JOIN favorite_artists
       ON appearance_artists.artist_id = favorite_artists.artist_id
       AND favorite_artists.user_id = #{user.id}
       WHERE appearance_artists.attachable_id = #{concert.id}
       AND appearance_artists.attachable_type = 'Concert'
       ORDER BY favorite_artists.id DESC"
    )
  }

  def self.create_or_find(params)
    self.create(params) unless self.find_by()
  end

  def setlist_url
    if setlist_path
      "http://www.livefans.jp" + setlist_path
    else
      nil
  end

  def update_concert_category
    concert = self.attachable
    if concert.appearance_artists.size >= Settings.fes_concerts_num
      concert.update(category: 1)
    else
      concert.update(category: 10)
    end
  end
end
