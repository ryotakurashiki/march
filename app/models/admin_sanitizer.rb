class Admin::ParameterSanitizer < Devise::ParameterSanitizer
  def initialize(*)
    super
    permit(:sign_up, keys: [:email, :passwrod, :passwrod_confirmation])
  end
end