module NewApi
  module V1
    class Users::SmsCodesController < ActionController::Base
      def create
        phone = params[:phone].to_s
        Sms::YunPian.send(phone)
        render json: {
          status: 201
        }
      end
    end
  end
end
