module NewApi
  module V1
    class BaseController < ActionController::API
      rescue_from ApiError, with: :handle_error

      protected

      def current_user
        token = params[:token].presence
        @current_user ||= User.find_by(auth_token: token.to_s)
      end

      def authenticate
        render json: {
          error: 'token is invalid'
        } unless current_user
      end

      def authenticate_teacher
        render json: {
          error: 'current_user is not a teacher'
        } unless current_user.class.name == "Teacher"
      end

      def handle_error(e)
        render json: { error_code: e.code, error_message: e.text }, status: e.status
      end
    end
  end
end
