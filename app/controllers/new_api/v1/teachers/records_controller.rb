module NewApi
  module V1
    class Teachers::RecordsController < Teachers::WorksController
      def index
      end

      def create
        load_teacher
        build_work
      end

      private
      def build_work
      end

      def work_params
      end
    end
  end
end