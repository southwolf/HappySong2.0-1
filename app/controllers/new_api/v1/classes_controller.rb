module NewApi
  module V1
    class ClassesController < BaseController

      def index
        classes = Org::Class.all
        render json: {
          classes: classes
        }
      end

      def code
        @class = Org::Class.find_by(code: params[:code])
        raise ClassNotFound unless @class
        render json:
          @class, serializer: OrgClass::ClassSerializer, status: 200 , adapter: :json, root: 'org_class'
      end
    end
  end
end
