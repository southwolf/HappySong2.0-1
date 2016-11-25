module NewApi
  module V1
    class CitiesController < BaseController
      def index
        @cities = Nation.cities
        render json:
          @cities, each_serializer: NationSerializer, root: "cities", adapter: :json
      end
    end
  end
end
