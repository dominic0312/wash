class LoginController < Devise::SessionsController
  layout "login"
  def after_sign_in_path_for(resource)

    products_path

  end
end