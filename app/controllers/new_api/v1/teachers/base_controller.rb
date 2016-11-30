module NewApi
  module V1
    class Teachers::BaseController < BaseController
      private
      def load_teacher
        @teacher = Teacher.find_by(id: params[:teacher_id])
        raise TeacherNotFound unless @teacher
      end
    end
  end
end
