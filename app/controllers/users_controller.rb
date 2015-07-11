class UsersController < InheritedResources::Base
  include Cartable
  # before_filter :extract_shopping_cart
  before_action :authenticate_user!

  layout "front"
  def profile
    @user = current_user
  end

  def update
    super do |format|
      format.html { redirect_to profile_path }
    end
  end





  private
  def user_params
    params.require(:user).permit(:mobile, :address, :alipay, :brand_name, :balance, :email, :promotion)
  end


end
