class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_confirmation_path_for(resource_name, resource)
    tutorial_path
    #root_path
  end

  def delete_space(text)
    text.gsub(/(\s|　)+/, '')
  end

  def after_sign_in_path_for(resource)
    admin_signed_in? ? admin_deactive_concerts_path : root_path
  end
end
