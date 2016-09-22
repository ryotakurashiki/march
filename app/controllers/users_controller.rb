class UsersController < ApplicationController
  before_action :set_user
  before_action :set_concerts
  def show
  	#render text: params[:username]
    @concerts = @this_user.concerts
    @artists = @this_user.artists
    @prefectures = @this_user.prefectures
  end

  def joining
    @concerts = @concerts.open.order("date")
  end

  def joined
    @concerts = @concerts.close.order("date DESC")
  end

  private

  def set_user
  	@this_user = User.find_by(username: params[:username])
  end

  def set_concerts
    @concerts = @this_user.concerts
  end
end
