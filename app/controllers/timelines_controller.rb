class TimelinesController < ApplicationController
  def top
  	render :welcome unless user_signed_in?

  	#@concerts = Concert.where()
  end
end
