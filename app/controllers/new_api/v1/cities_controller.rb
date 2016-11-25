module NewApi
  module V1
    class CitiesController < BaseController
      def index
        @cities = Nation.cities
        render json: {
          cities: @cities
        }
      end
    end
  end
end
