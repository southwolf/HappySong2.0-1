module NewApi
  module V1
    class Students::WorksController < Students::BaseController

      def index # 学生查看作业列表
        load_student
        works = @student.student_works
        render json:
          works, each_serializer: Student::WorkSerializer, status: 200, root: 'works', adapter: :json
      end
    end
  end
end
