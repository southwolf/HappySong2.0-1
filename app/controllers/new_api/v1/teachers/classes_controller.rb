module NewApi
  module V1
    class Teachers::ClassesController < Teachers::BaseController
      def index
        load_teacher
        classes = @teacher.classes
        render json:
          classes, each_serializer: ClassSerializer, status: 200, root: "classes", adapter: :json
      end

      def edit
        load_teacher
        load_class
      end

      private
      def load_class
        @class = Org::Class.find_by(id: params[:id])
        raise ClassNotFound unless @class
      end
    end
  end
end
