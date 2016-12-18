module NewApi
  module V1
    class BaseController < ActionController::API
      rescue_from ApiError, with: :handle_error
      before_action :set_model_current_user

      protected
      def handle_error(e)
        render json: { error_code: e.code, error_message: e.text }, status: e.status
      end

      def set_model_current_user
        User.current = current_user
      end

      def current_user
        token = params[:token].presence
        @current_user ||= User.find_by(auth_token: token.to_s)
      end

      def authenticate
        raise MissingAuthTokenError unless current_user
      end

      def authenticate_teacher
        raise InvalidTeacherAuthorizationError unless current_user.class.name == "Teacher"
      end
    end
  end
end
