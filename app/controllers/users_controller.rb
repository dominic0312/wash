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
    message = "尊敬的会员您好，您的账户已经开通成功，用户名为手机号，初始密码为#{password}，请及时登录修改密码【家家商城】"
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

  def go_alipay(sid, orderid, fee)

    Alipay::Service.create_direct_pay_by_user_url(
        out_trade_no: sid,
        subject: orderid,
        total_fee: fee,
        return_url: 'http://www.jiajiaxishangcheng.com/charge_return/' + sid,
        notify_url: 'http://www.jiajiaxishangcheng.com/charge_notify/' + sid
    )

  end

  def charge_account

    charge = Charge.new(:user_id => current_user.id, :amount => params[:product][:amount].to_i)

    charge.sn = "CHR" + Time.now.to_formatted_s(:number)
    charge.save!
    url = go_alipay(charge.sn, "充值订单"+charge.sn, charge.amount.to_f)
    redirect_to url and return
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
