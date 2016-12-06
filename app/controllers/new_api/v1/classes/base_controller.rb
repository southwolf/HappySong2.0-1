module NewApi
  module V1
    class Classes::BaseController < BaseController
      private
      def load_class
        @class = Org::Class.find_by(id: params[:class_id]) #TODO 登录用户自己的
        raise ClassNotFound unless @class
      end
    end
  end
end
