module NewApi
  module V1
    class Students::ProfileController < Students::BaseController
      def index
        load_student
        render json:
          @student, serializer: Student::ProfileSerializer, status: 200, root: "user", adapter: :json
      end

      protected
      def load_student
        @student = Student.includes(:org_classes).find_by(id: params[:student_id])
        raise StudentNotFound unless @student
      end
    end
  end
end
