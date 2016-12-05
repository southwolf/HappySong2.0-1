module NewApi
  module V1
    class Nations::SchoolsController < BaseController
      before_action :load_nation
      
      def index
        schools = @nation.schools
        render json:
          schools, each_serializer: SchoolSerializer, adapter: :attributes
      end

      private
      def load_nation
        @nation = Nation.find_by(id: params[:nation_id])
        raise NationNotFound unless @nation
      end
    end
  end
end
