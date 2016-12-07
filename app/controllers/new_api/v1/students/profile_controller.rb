module NewApi
  module V1
    class Students::ProfileController < Students::BaseController
      def index
        load_student
        render json:
          @student, serializer: Student::ProfileSerializer, status: 200, root: "user", adapter: :json
      end
    end
  end
end
