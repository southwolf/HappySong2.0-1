module NewApi
  module V1
    class Students::WorksController < Students::BaseController

      def index # 学生查看作业列表
        load_student
        @works = @student.home_works
      end
    end
  end
end
