module V1
  class ProvincesApi < Grape::API

    resources :provinces do
     desc "获取所有省份"
      get do
        provinces = Province.all
        present provinces, with: ::Entities::Province
        status 200
      end
    end

    resources :cities do
      desc "取得 city 如果带上province_id为省会下的城市，不带则返回所有城市"
      params do
        optional :province_id, type: Integer, desc: "城市ID"
      end
      get do
        province_id = params[:province_id]
        if province_id.nil?
          cities = City.all
        else
          cities = City.where(province_id: province_id)
        end
        present cities, with: ::Entities::City
        status 200
      end
    end

    resources :districts do
      desc '取得 district 如果带上 city_id 为 城市下的区（县），不带则返回所有区（县）'
      params do
        optional :city_id, type: Integer, desc: 'city_id 城市 id.'
      end
      get do
        city_id = params[:city_id]
        if city_id.nil?
          districts = District.all
        else
          districts = District.where(city_id:city_id)
        end
        present  districts, with: ::Entities::District
        status 200
      end
    end

  end
end
