
module NewApi
  module V1
    class Students::DynamicsController < Students::BaseController

      def index # 学生查看自己的创作列表
        load_student
        works = @student.student_works
        render json:
          works, each_serializer: Student::WorkSerializer, status: 200, root: 'works', adapter: :json
      end

      def create # 学生发布少年说
      end

      def destroy # 学生删除少年说
      end
    end
  end
end
