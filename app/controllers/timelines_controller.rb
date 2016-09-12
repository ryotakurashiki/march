class TimelinesController < ApplicationController
  def timeline
  	render :welcome unless user_signed_in?

  	@concerts = current_user.concerts
  end
end
