class FrontController < BaseController
  before_action :authenticate_user!
  layout "front"
  def index
    @products = Product.all
  end



end




