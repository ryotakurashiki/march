class CardImagesController < ApplicationController
  before_action :set_user
  layout "card_image_application"

  def joining
  end

  def joined
  end

  private

  def set_user
  	@this_user = User.find_by(username: params[:username])
  end
end
