class User::UserApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :finish_tutorial

  def finish_tutorial
    if current_user.tutorial_finished
      unless action_name.match(/^tutoria/)
        redirect_to tutorial_path if request.get?
      end
    end
  end

  #layout "user_application"
end
