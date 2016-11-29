module NewApi
  module V1
    class Users::SmsCodesController < ActionController::Base
      def create
        phone = params[:phone].to_s
        response = Sms::YunPian.send(phone)
        render json: response
      end
    end
  end
end
