class RegController < Devise::RegistrationsController

  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation, :login, :mobile,:promotion,:uname)}
  end


  def new
    @user = User.new
    @promotion = params[:promotion]

  end

  def create

    super
  end

  def update
    super
  end


  def promotion
    @promotion_id = params[:id]
    @user=User.new
    redirect_to new_user_registration_path(:promotion => @promotion_id)
  end


end