class FrontController < BaseController
  # before_action :authenticate_user!
  layout "login"
  def index
    @products = Product.all
  end



end




