module NewApi
  module V1
    class Students::BaseController < BaseController
      protected
      # TODO 这里其实应该用 token 来比对一次 确认当前用户
      def load_student
        @student = Student.find_by(id: params[:student_id])
        raise StudentNotFound unless @student
      end
    end
  end
end
