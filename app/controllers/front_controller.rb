class FrontController < ApplicationController
  # before_action :authenticate_user!
  layout "login"
  def index
    @products = Product.all
  end



end




