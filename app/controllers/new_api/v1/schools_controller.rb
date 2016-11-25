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
        @school = Org::School.new(school_params)
        if @school.save
          render json: {
            school: @school
          }
        else
          render json: {
            error: '400'
          }
        end
      end

      private
      def school_params
        params.require(:school).permit(:nation_id, :name)
      end
    end
  end
end
