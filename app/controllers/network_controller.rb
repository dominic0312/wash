class NetworkController < BaseController
  before_action :authenticate_user!
  layout "front"
  def index
   @children = current_user.children
   @user = User.new
  end

  def create
    uname = params[:user][:mobile]
    if User.exists?(:mobile => uname)
       redirect_to network_path and return
    end


    u = User.new(:mobile => uname)
    u.parent = current_user
    u.source = "input"
    u.save!
    redirect_to network_path
  end

end




