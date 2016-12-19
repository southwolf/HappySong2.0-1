module NewApi
  module V1
    class Works::BaseController < BaseController
      before_action :authenticate
      before_action :load_class
      protected
      def load_class
        @current_class ||= current_user.current_class
      end

      def load_work
        @work = HomeWork.find_by(id: params[:work_id])
        raise HomeWorkNotFound unless @work
        @work
      end

      def load_students
        @students = Student.where(id: load_student_works.pluck(:student_id))
      end
    end
  end
end
