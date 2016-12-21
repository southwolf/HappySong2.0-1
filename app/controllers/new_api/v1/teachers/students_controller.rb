module NewApi
  module V1
    class Teachers::StudentsController < Teachers::BaseController
      def index
        load_teacher
        students = @teacher.students
        render json:
          students, each_serializer: StudentSerializer, status: 200, root: "students", adapter: :json
      end
    end
  end
end
