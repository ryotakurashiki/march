class User < ApplicationRecord
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

  def self.from_omniauth(auth)
    where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
      user.email = "#{auth.uid}@#{auth.provider}"
      user.password = Devise.friendly_token[0,20]
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
      user.username_jp = auth["info"]["name"]
      user.description = auth["info"]["description"].to_s[0,255]
      user.icon = auth["info"]["image"].to_s.sub('normal', 'bigger')
      user.skip_confirmation!
    end
  end

  def next_live
    concerts.open.order("date").limit(1).first
  end

  def last_live
    concerts.close.order("date desc").limit(1).first
  end

  def recommended_artist_ids
    favorite_artists.map{|fa| fa.artist.related_artist_ids}.flatten.uniq
    #favorite_artists.map{|favorite_artist| favorite_artist.artist.artists }.uniq
    #Artist.where(id: favorite_artists.map{|favorite_artist| favorite_artist.artist.artists }.uniq)
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
end
