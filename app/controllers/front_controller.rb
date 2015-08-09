class FrontController < ApplicationController
  # before_action :authenticate_user!
  layout "front"
  def index
    @products = Product.all
  end
end




