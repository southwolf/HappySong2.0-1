# 老师 -> 作业 控制器
module NewApi
  module V1
    class Teachers::WorksController < Teachers::BaseController
      before_action :authenticate

      def show

      end
    end
  end
end
