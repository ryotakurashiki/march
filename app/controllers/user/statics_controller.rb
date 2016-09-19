class User::StaticsController < User::UserApplicationController
  def profile
    @user = current_user
    @favorite_prefectures = @user.favorite_prefectures
  end

  def search
    recommended_artist_ids = current_user.recommended_artist_ids
    favorite_artist_ids = current_user.favorite_artists.pluck(:artist_id)
    recommended_artist_ids -= favorite_artist_ids

    #render text: recommended_artist_ids
    @recommended_artists = Artist.where(id: recommended_artist_ids.shuffle[1..30])
  end
end

