class FrontController < ApplicationController
  # before_action :authenticate_user!
  layout "front"
  def index
    @products = Product.all
  end


  def advice

  end


  def  brand

  end

  def benefit

  end

  def member

  end


end




