class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # before_filter :extract_shopping_cart
  # protect_from_forgery with: :exception
  #
  # private
  # def extract_shopping_cart
  #   shopping_cart_id = session[:shopping_cart_id]
  #   @cart = session[:shopping_cart_id] ? Cart.find(shopping_cart_id) : Cart.create
  #   session[:shopping_cart_id] = @cart.id
  # end

  before_action :configure_permitted_parameters, if: :devise_controller?

  # def after_sign_in_path_for(user)
  #   front_path
  # end
  #
  # def after_sign_out_path_for(user)
  #   new_user_session_path
  # end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:mobile, :email, :password, :password_confirmation, :remember_me, :uname) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :mobile, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:mobile, :email, :password, :password_confirmation, :current_password) }
  end


end
