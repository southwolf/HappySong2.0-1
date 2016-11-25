module NewApi
  module V1
    class ClassesController < BaseController
      before_action :authenticate, only: [:create]
      before_action :ensure_school, only: [:create]

      def index
        @classes = Org::Class.all
        render json: {
          classes: @classes
        }
      end

      def show
      end

      def create
      end

      private
      def class_params
      end
      def school_params
      end

      def ensure_school
        @school = Org::School.find_by(id: params[:school_id])
        @school = Org::School.create(

        ) unless @school
      end
    end
  end
end
