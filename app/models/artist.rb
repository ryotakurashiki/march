class Artist < ApplicationRecord
  after_create :create_kana, dependent: :destroy

  has_many :appearance_artists, dependent: :destroy
  accepts_nested_attributes_for :appearance_artists
  has_many :concerts, through: :appearance_artists, source: 'attachable', source_type: 'Concert'
  has_many :artist_relations
  has_many :medium_artist_relations
  has_many :media, through: :medium_artist_relations
  has_many :favorite_artists
  accepts_nested_attributes_for :favorite_artists
  has_many :users, through: :favorite_artists
  has_many :artists, through: :artist_relations, foreign_key: :related_artist_id
  has_many :kanas

  validates :name, uniqueness: true

  scope :artist_relations_nil, -> {
    includes(:artist_relations, :medium_artist_relations).
    where(artist_relations: {related_eplus_artist_id: nil}, medium_artist_relations: {medium_id: 1})
  }
  scope :search_match_artists, -> (match_text) {
    find_by_sql(
      "SELECT artists.* from artists
       LEFT OUTER JOIN kanas ON artists.id = kanas.artist_id
       WHERE kanas.name LIKE \'#{match_text}\' limit 20"
    ).uniq
  }
  scope :artist_relations_small, -> (num) {
    find_by_sql(
      "SELECT * FROM artists WHERE id not in (
        SELECT artist_id FROM artist_relations
        GROUP BY artist_id HAVING COUNT(*) > #{num}
      )"
    )
  }

  def eplus_url
    medium_artist_relations.find_by(medium_id: 1).eplus_url
  end

  def related_artist_ids
    artist_relations.pluck(:related_artist_id).uniq
  end

  def favorite_by?(user)
    return false if user.nil?
    favorite_artists.pluck(:user_id).include?(user.id)
  end

  def create_kana
    kana_name = self.name.gsub(/(\s|　)+/, '')
    Kana.create(name: kana_name, artist_id: self.id)
  end

  def self.find_or_create_by(params)
  	self.find_by(name: params[:name]) || self.create(params)
  end
end
