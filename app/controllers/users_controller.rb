class UsersController < InheritedResources::Base
  include Cartable
  # before_filter :extract_shopping_cart
  before_action :authenticate_user!, except: :notice

  layout "shop"
  def profile
    @user = current_user
  end


  def charge

  end

  def password
    @user = current_user
  end


  def notice
    # puts "user id is " + params[:id]
    u = User.find(params[:id])
    if u
      send_sms(u.mobile, u.pass)
      render :js => "alert('通知发送成功')"
    else
      render :js => "alert('通知发送失败，用户不存在')"
    end

  end



  def send_sms(mobile, password)
    message = "您已经被家家商城邀请为会员，您的登录手机号是#{mobile}, 初始密码是#{password},
    请登录 www.jiajiaxishangcheng.com 来购物.【家家商城】"
    uri = URI('https://sms-api.luosimao.com/v1/send.json')
    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https',
                    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Post.new uri.path
      # mobile2='13590296140'
      data = {'mobile' => mobile, 'cb' => 'callback', 'message' => message}
      request.form_data = data
      request.basic_auth 'api', '618b92cc656f8e532bb2c08a0d8d205a'
      response = http.request request # Net::HTTPResponse object
      puts response
      puts response.body
    end
  end


  def charge_account

    redirect_to profile_path
  end


  def change_pass
    u = current_user
    u.password = params[:reg_password]
    u.password_confirmation = params[:reg_password_confirm]
    u.save!
    redirect_to password_path
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
