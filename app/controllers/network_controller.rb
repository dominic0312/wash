class NetworkController < BaseController
  before_action :authenticate_user!
  layout "shop"
  def index
   @children = current_user.children
   @user = User.new
  end

  def create
    uname = params[:user][:mobile]
    brand = params[:user][:brand_name]
    @children = current_user.children
    @user = User.new
    if User.exists?(:mobile => uname)
       @notice = "用户已经存在, 无法新增会员"
       render "index" and return
    end


    u = User.new(:mobile => uname, :brand_name=>brand)
    u.parent = current_user
    u.source = "input"
    u.save!

    m_brand = current_user.brand_name
    send_sms(uname, m_brand, u.pass)
    render "index" and return
  end


  def send_sms(mobile, brand, pass)
    usr = brand ? "的#{brand}": ""


    message = "您已经被手机号:13561070828#{usr}会员邀请为家家商城用户, 您可以用本手机号和密码#{pass}进入 ,
    请登录 www.jiajiaxishangcheng.com 来购物.【家家商城】"
    puts message
    uri = URI('https://sms-api.luosimao.com/v1/send.json')
    Net::HTTP.start(uri.host, uri.port,
                    :use_ssl => uri.scheme == 'https',
                    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Post.new uri.path
      # mobile2='13590296140'
      data = {'mobile' => mobile, 'cb' => 'callback', 'message' => message}
      request.form_data = data
    
                    
      response = http.request request # Net::HTTPResponse object
      puts response
      puts response.body
    end
  end

end




