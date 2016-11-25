module NewApi
  module V1
    class ClassesController < BaseController
      before_action :authenticate, only: [:create]

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
    end
  end
end
