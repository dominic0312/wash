class RegController < Devise::RegistrationsController

  before_filter :update_sanitized_params, if: :devise_controller?
  require "uri"
  require 'net/https'

  def perform( mobile, message)

  end


  layout "login"
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation, :login, :mobile,:promotion,:uname)}
  end


  def new
    @user = User.new
    @promotion = params[:promotion]
 end

  def create
    create_mobile(params)
    # super
  end

  def update
    super
  end


  def create_mobile(params)
    # valid = true
    valid = Verification.where(:phone => params[:reg_phone]).first
    if valid
      if User.exists?(:mobile => valid.phone)
        render :js => "alert('电话号码已经存在,请用别的号码注册')" and return
      end

      if valid.verify_code == params[:reg_code]
        u = User.new
        u.mobile = valid.phone
        # u.mobile = params[:reg_phone]
        u.password = u.password_confirmation = params[:reg_password]
        if params[:promotion]
          if User.exists?(:promotion_code => params[:promotion])
            u.parent_id = User.where(:promotion_code => params[:promotion]).first.id
          end
        end
        u.save!
        # valid.phonestatus = "verified"
        # u.verification = valid
        # u.user_info.mobile = valid.phone
        # u.user_info.save!
        # valid.save!
        render "success" and return

      else
        @message = "验证码不正确，请重新验证"
        render "fail"
        # render :js => "alert('验证没有通过')" and return
      end
    else
      @message = "手机验证失败，请重新注册"
      render "fail"
      # render :js => "alert('验证码无效,请重新申请')" and return
    end
  end









  def send_sms(mobile, code)
    message = "感谢您注册家家商城，您的验证码是#{code}【家家商城】"
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



  def get_code
    valid = Verification.where(:phone => params[:phone_num]).first
    if User.exists?(:mobile => params[:phone_num])
      render :js => "alert('该手机号码已经被注册')" and return
    end
    verify_code = rand(10 ** 6)

    # send_sms(params[:phone_num], verify_code)
    if valid
      if valid.phonestatus == "verified"
        render :js => "alert('该手机号码已经被注册')" and return
      else
        valid.verify_code = verify_code
        valid.save!
        send_sms(params[:phone_num], verify_code)
       # render :js => "alert('验证码为#{verify_code}')" and return
      end
    else
      valid = Verification.new
      valid.phone = params[:phone_num]
      valid.verify_code = verify_code
      valid.save!
      send_sms(params[:phone_num], verify_code)
      return
      # render :js => "alert('验证码为#{verify_code}')"  and return
    end
  end


  def promotion
    @promotion_id = params[:id]
    @user=User.new
    redirect_to new_user_registration_path(:promotion => @promotion_id)
  end


  def checkmobile
    if User.exists?(:mobile => params[:reg_phone])
      render :json => "false" and return
    else
      render :json => "true" and return
    end
  end


end