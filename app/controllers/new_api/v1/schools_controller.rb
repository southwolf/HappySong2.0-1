module NewApi
  module V1
    class SchoolsController < BaseController
      before_action :authenticate, only: [:create]

      def index
        @schools = Org::School.all.page(params[:page])
        render json: {
          schools: @schools,
          meta: {
            page: params[:page],
            total: School.count
          }
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
