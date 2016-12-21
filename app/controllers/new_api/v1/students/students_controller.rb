module NewApi
  module V1
    class Students::StudentsController < Students::BaseController

      def index
        load_student
        students = Student.where(id:  (ClassStudent.where(class_id: @student.org_classes.pluck(:id)).pluck(:student_id).uniq - [@student.id]))
        render json:
          students, each_serializer: StudentSerializer, root: 'students', adapter: :json
      end

      protected
      def load_student
        @student = Student.includes(:org_classes).find_by(id: params[:student_id])
        raise StudentNotFound unless @student
      end
    end
  end
end
