class User::StaticsController < User::UserApplicationController
  def account
    @user = current_user
    @favorite_prefectures = @user.favorite_prefectures
  end

  def update
    #if @inquiry.valid?
    @user = current_user.update(user_params)
    redirect_to account_path
  end

  def search
    recommended_artist_ids = current_user.recommended_artist_ids
    favorite_artists = current_user.favorite_artists
    @favorite_artist_ids = favorite_artists.pluck(:artist_id)
    recommended_artist_ids -= @favorite_artist_ids
    @recommended_artists = Artist.where(id: recommended_artist_ids.shuffle[1..30])
  end

  def search_filter
    match_text = '%'+params[:input_text]+'%'
    @favorite_artist_ids = current_user.favorite_artists.pluck(:artist_id)
    if params[:input_text].present?
      @artists = Artist.where(Artist.arel_table[:name].matches(match_text)).limit(5)
    else
      @artists = nil
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :username_jp, :description, :icon)
  end
end

