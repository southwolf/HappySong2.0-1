module NewApi
  module V1
    class Cities::CountriesController < BaseController
      def index
        load_city
        @counties = @city.children if @city
        @counties = Nation.counties unless @counties
        render json:
          @counties, each_serializer: NationSerializer, adapter: :attributes
      end

      private
      def load_city
        @city = Nation.find_by(id: params[:city_id])
      end
    end
  end
end
