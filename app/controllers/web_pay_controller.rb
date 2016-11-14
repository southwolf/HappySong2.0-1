class WebPayController < ApplicationController

  def pay
    @user = User.find_by_auth_token(params[:token])
    # redirect_to "http://www.rabbitpre.com/m/7IRInVRAm"

    render layout: false
  end

  def other_pay
    @user = User.find_by_auth_token(params[:token])
    # redirect_to "http://www.rabbitpre.com/m/7IRInVRAm"

    render layout: false
  end
  def success
    
  end

  def cancel

  end
end
