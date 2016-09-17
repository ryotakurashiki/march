class OmniauthCallbacksController < ApplicationController
  def twitter
    uid = request.env["omniauth.auth"]["uid"]
    provider = request.env["omniauth.auth"]["provider"]
    redirected = User.find_by(uid: uid, provider: provider) ? root_path : tutorial_path
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))
    if @user.persisted?
      flash.notice = "Twitter認証が完了しました！"
      sign_in(@user)
      redirect_to redirected
    else
      session["devise.user_attributes"] = @user.attributes
      redirect_to root_path
    end
  end
end
