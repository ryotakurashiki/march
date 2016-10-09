class User::UserConcertJoiningsController < User::UserApplicationController
  # POST /artists
  # POST /artists.json
  def create
    @user_concert_joining = UserConcertJoining.find_by(concert_id: params[:concert_id], user_id: current_user.id)
    if @user_concert_joining
      @user_concert_joining.destroy
      render "destroy.js"
    else
      @user_concert_joining = UserConcertJoining.create(concert_id: params[:concert_id], user_id: current_user.id)
      @join_counts = current_user.user_concert_joinings.size
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @favorite_artist.destroy
  end

end
