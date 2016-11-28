module NewApi
  module V1
    class CitiesController < BaseController
      
      def index
        cities = Nation.cities
        if cities
          render json:
            cities, each_serializer: NationSerializer, status: 200, root: "cities", adapter: :json
        else
          raise RecordNotFound
        end
      end
    end
  end
end
