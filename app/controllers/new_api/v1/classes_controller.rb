module NewApi
  module V1
    class ClassesController < BaseController

      def index
        classes = Org::Class.all
        render json: {
          classes: classes
        }
      end
    end
  end
end
