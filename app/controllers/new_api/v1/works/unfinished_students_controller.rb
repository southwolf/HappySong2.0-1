module NewApi
  module V1
    class Works::UnfinishedStudentsController < Works::BaseController
      # 某个具体的作业已经完成的学生列表
      def index
        load_students
        render json:
          @students, status: 200, root: 'students', adapter: :json
      end

      protected
      def load_student_works
        @student_works = load_work.student_works.unfinished
        raise StudentWorkNotFound unless @student_works
        @student_works
      end
    end
  end
end
