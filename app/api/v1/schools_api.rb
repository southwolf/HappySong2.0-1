module V1
  class SchoolsApi < Grape::API
    resources :schools do
      desc "如果带上 district_id 为 城市下的学校，不带则返回所有学校"
      params do
        optional :district_id, type: Integer, desc: '区域ID'
      end
      get do
        district_id = params[:district_id]
        if district_id.nil?
          schools = School.all
        else
          schools = School.where(district_id: district_id)
        end
        present :schools, schools, with: ::Entities::School
      end
    end
  end
end
