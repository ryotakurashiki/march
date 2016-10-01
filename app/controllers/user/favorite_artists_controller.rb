class User::FavoriteArtistsController < User::UserApplicationController
  # POST /artists
  # POST /artists.json
  def show
    @artists = current_user.artists.includes(:favorite_artists).resources(:favorite_artists)
  end

  def create
    #@favorite_artist = FavoriteArtist.new(artist_id: params[:artist_id], user_id: current_user.id)
    @favorite_artist = FavoriteArtist.find_by(artist_id: params[:artist_id], user_id: current_user.id)
    if @favorite_artist
      @favorite_artist.destroy
      render "destroy.js"
    else
      @favorite_artist = FavoriteArtist.new(artist_id: params[:artist_id], user_id: current_user.id)
      old_recommended_artist_ids = current_user.recommended_artist_ids
      if @favorite_artist.save
        new_recommended_artist_ids = @favorite_artist.artist.related_artist_ids - old_recommended_artist_ids
        @related_artists = Artist.where(id: new_recommended_artist_ids, category: nil)
        @favorite_counts = current_user.favorite_artists.size
        @favorite_artist_ids = current_user.favorite_artists.pluck(:artist_id)
      else
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @favorite_artist.destroy
  end

end
