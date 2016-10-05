class User < ApplicationRecord
  before_create :set_usernames
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:twitter]

  has_many :favorite_artists
  has_many :artists, through: :favorite_artists
  has_many :favorite_prefectures
  has_many :prefectures, through: :favorite_prefectures
  has_many :user_concert_joinings
  has_many :concerts, through: :user_concert_joinings
  has_many :watched_artists, through: :user_concert_joinings
  mount_uploader :icon, ImageUploader

  #validates :email, presence: true
  #validates :username, presence: true
  #validates :username_jp, :presence => {:message => 'ユーザー名を入力してください'}

  def set_usernames
    self.username = self.username || get_random_string(8)
  end

  def self.from_omniauth(auth)
    where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
      user.email = "#{auth.uid}@#{auth.provider}"
      user.password = Devise.friendly_token[0,20]
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
      user.username_jp = auth["info"]["name"]
      user.description = auth["info"]["description"].to_s[0,255]
      user.icon_tw = auth["info"]["image"].to_s.sub('normal', 'bigger')
      user.skip_confirmation!
    end
  end

  def icon_path
    if icon.present?
      return icon
    elsif icon_tw.present?
      return icon_tw
    else
      return "default_icon.png"
    end
  end

  def next_live
    concerts.open.order("date").limit(1).first
  end

  def last_live
    concerts.close.order("date desc").limit(1).first
  end

  def recommended_artist_ids
    ArtistRelation.joins(:artist).merge(artists).group(:related_artist_id).pluck(:related_artist_id)
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  private

  def get_random_string (length = 8)
    source = ("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a
    key = ""
    length.times{ key += source[rand(source.size)].to_s }
    return key
  end
end
