module NewApi
  module V1
    class Classes::StudentsController < Classes::BaseController
      def index
        load_class
        students = @class.students
        render json:
          students, each_serializer: StudentSerializer, adapter: :json
      end
    end
  end
end
