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
    @favorite_artist_ids = current_user.favorite_artists.pluck(:artist_id)
    if params[:input_text].present?
      input_space_deleted = delete_space(params[:input_text])
      match_text = '%'+input_space_deleted+'%'
      @artists = Artist.search_match_artists(match_text).sort_by { |a| a.name.size }
    else
      @artists = nil
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :username_jp, :description, :icon)
  end
end

