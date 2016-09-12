class UsersController < ApplicationController
  before_action :set_user
  def show
  	#render text: params[:username]
    @concerts = @this_user.concerts
    @artists = @this_user.artists
    @prefectures = @this_user.prefectures
  end

  private

  def set_user
  	@this_user = User.find_by(username: params[:username])
  end
end
