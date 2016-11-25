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
            total: Org::School.count
          }
        }
      end

      def create
        @school = Org::School.new(school_params)
        if @school.save
          render json:
            @school, serializer: SchoolSerializer, adapter: :attributes
        else
          render json: {
            error: 400
          }
        end
      end

      private
      def school_params
        _school_params = params.fetch(:school, {}).permit(:name, :nation_id)
        _school_params = params.permit(:name, :nation_id) if _school_params.blank?
        _school_params
      end
    end
  end
end
