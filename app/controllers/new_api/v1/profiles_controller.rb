module NewApi
  module V1
    class ProfilesController < BaseController
      before_action :load_user

      def show
        render json: {
          user: @user
        }
      end

      private
      def load_user
        @user = User.find_by(id: params[:id])
      end
    end
  end
end
