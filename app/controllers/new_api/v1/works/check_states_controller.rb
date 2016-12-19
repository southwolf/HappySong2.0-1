module NewApi
  module V1
    class Works::CheckStatesController < Works::BaseController
      # 学生查看某个具体作业完成状态
      def index
        load_student_work
        render json: {
          work: {
            id: @student_work.work_id,
            state: @student_work.state
          }
        }
      end

      protected
      def load_student_work
        @student_work = load_work.student_works.find_by(student_id: current_user.id)
        raise StudentWorkNotFound unless @student_work
      end
    end
  end
end
