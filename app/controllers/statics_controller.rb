class StaticsController < ApplicationController
  def welcome
  	redirect_to timeline_future_path if user_signed_in?
  end
end
