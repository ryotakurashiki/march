class StaticsController < ApplicationController
  def welcome
  	redirect_to concerts_path if user_signed_in?
  end
end
