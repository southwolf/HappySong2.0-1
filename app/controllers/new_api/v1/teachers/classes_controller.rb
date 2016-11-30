module NewApi
  module V1
    module Teachers
      class ClassesController < BaseController
        def index
          load_teacher
          classes = @teacher.classes
          render json:
            classes, each_serializer: ClassSerializer, status: 200, root: "classes", adapter: :json
        end
      end
    end
  end
end
