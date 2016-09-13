class MediumArtistRelation < ApplicationRecord
  belongs_to :artist
  belongs_to :medium

  def eplus_url
  	"https://eplus.jp/ath/word/" + medium_artist_id
  end
end
