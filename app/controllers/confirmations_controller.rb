class ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      sign_in(resource) # これを追加した
      #respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
      respond_with_navigational(resource){ redirect_to tutorial_path } # tutorialにredirect先を変更
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end
end