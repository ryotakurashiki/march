class User::FavoriteArtistsController < User::UserApplicationController
  # POST /artists
  # POST /artists.json
  def create
    old_recommended_artist_ids = current_user.recommended_artist_ids
    @favorite_artist = FavoriteArtist.new(artist_id: params[:artist_id], user_id: current_user.id)
    if @favorite_artist.save
      new_recommended_artist_ids = @favorite_artist.artist.related_artist_ids - old_recommended_artist_ids
      @related_artists = Artist.where(id: new_recommended_artist_ids)
      @favorite_counts = current_user.favorite_artists.size
    else
    end
  end

  # PATCH/PUT /artists/1
  # PATCH/PUT /artists/1.json
  def update
    respond_to do |format|
      if @artist.update(artist_params)
        format.html { redirect_to @artist, notice: 'Artist was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist }
      else
        format.html { render :edit }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'Artist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

end
