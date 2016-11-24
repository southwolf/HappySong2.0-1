module NewApi
  module V1
    class SchoolsController < BaseController
      before_action :authenticate, only: [:create]

      def index
        render json: {
          schools: Org::School.all.page(params[:page])
        }
      end

      def create
        
      end

      private
      def school_params

      end
    end
  end
end
