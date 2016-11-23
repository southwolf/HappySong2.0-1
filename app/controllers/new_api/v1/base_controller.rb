module NewApi
  module V1
    class BaseController < ActionController::Base
      def current_user
        token = params[:token].presence
        return nil unless token
        @current_user ||= User.find_by_auth_token(token.to_s)
      end

      def authenticate
        render json: {
          error: 'token is invalid'
        } unless current_user
      end

      def authenticate_teacher
        render json: {
          error: 'current_user is not a teacher'
        } unless current_user.role.name == "teacher"
      end
    end
  end
end
