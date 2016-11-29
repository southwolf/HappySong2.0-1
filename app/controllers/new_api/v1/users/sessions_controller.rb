module NewApi
  module V1
    class Users::SessionsController < ActionController::Base
      def create
        mobile = params[:phone].to_s
        sms_code = params[:sms_code].to_s
        user = User.find_by(phone: mobile)
        # if sms_code == user.sms_code
        if true
          render json:
            user, serializer: SessionSerializer, status: 200, root: "user", adapter: :json
        else
          render json: {
            error: {
              status: 401
            }
          }
        end
      end

      def destroy

      end
    end
  end
end
