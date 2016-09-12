class User::UserApplicationController < ApplicationController
  before_action :authenticate_user!

  #layout "user_application"
end
