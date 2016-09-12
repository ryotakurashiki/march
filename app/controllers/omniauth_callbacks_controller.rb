class OmniauthCallbacksController < ApplicationController
  def twitter
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))

    #@user.skip_confirmation!
    #@user.save!

    if @user.persisted?
      flash.notice = "Twitter認証が完了しました！"

       #redirect_to controller: 'confirmations', action: 'show', confirmation_token: @user.confirmation_token
       sign_in_and_redirect @user
    else
      session["devise.user_attributes"] = @user.attributes
      redirect_to new_user_registration_url
    end
  end
end
