module NewApi
  module V1
    class Students::WorksController < Students::BaseController

      def index # 学生查看作业列表
        load_student
        works = @student.student_works
        render json:
          works, each_serializer: Student::WorkSerializer, status: 200, root: 'works', adapter: :json
      end

      def show # 学生查看作业详情
        work = HomeWork.find_by(id: params[:id])
        raise HomeWorkNotFound unless work
        render json:
          work, serializer: Student::ShowWorkSerializer, status: 200, root: 'work', adapter: :json
      end
    end
  end
end
