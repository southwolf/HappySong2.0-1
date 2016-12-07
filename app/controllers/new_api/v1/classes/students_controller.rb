module NewApi
  module V1
    class Classes::StudentsController < Classes::BaseController
      before_action :authenticate

      def index
        load_class
        students = @class.students
        render json:
          students, each_serializer: StudentSerializer, adapter: :json
      end
    end
  end
end
