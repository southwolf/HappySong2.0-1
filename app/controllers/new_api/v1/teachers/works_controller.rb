# 老师 -> 作业 控制器
module NewApi
  module V1
    class Teachers::WorksController < Teachers::BaseController
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