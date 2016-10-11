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

  def update_favorite_prefecture(prefecture_id)
    if user_signed_in?
      if prefecture_id.present?
        if current_user.favorite_prefectures.present?
          current_user.favorite_prefectures.first.update(prefecture_id: prefecture_id)
        else
          current_user.favorite_prefectures.create(prefecture_id: prefecture_id)
        end
      else
        current_user.favorite_prefectures.destroy_all
      end
    end
  end
end
