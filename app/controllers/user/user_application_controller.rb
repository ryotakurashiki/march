class User::UserApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :finish_tutorial

  def finish_tutorial
    unless current_user.tutorial_finished
      unless controller_name.match(/^tutoria/)
        redirect_to tutorial_path if request.get?
      end
    end
  end
  #layout "user_application"
end
