class User::StaticsController < User::UserApplicationController
  def profile
    @user = current_user
    @favorite_prefectures = @user.favorite_prefectures
  end

  def search
    recommended_artist_ids = current_user.recommended_artist_ids
    favorite_artists = current_user.favorite_artists
    favorite_artist_ids = favorite_artists.pluck(:artist_id)
    recommended_artist_ids -= favorite_artist_ids

    @all_artists = Artist.all
    #@all_artists = Artist.eager_load(:favorite_artists).merge(FavoriteArtist.where(user_id: current_user.id))
     #Artist.where(id: [9160, 9180]).eager_load(:favorite_artists).merge(FavoriteArtist.where(user_id: 30))

    @recommended_artists = Artist.where(id: recommended_artist_ids.shuffle[1..30])
  end
end

