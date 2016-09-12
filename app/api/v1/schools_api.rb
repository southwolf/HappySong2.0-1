module V1
  class SchoolsApi < Grape::API
    resources :schools do
      desc "如果带上 district_id 为 城市下的学校，不带则返回所有学校"
      params do
        optional :district_id, type: Integer, desc: '区域ID'
      end
      get do
        district_id = params[:district_id].to_i
        if district_id.nil?
          schools = School.all
        else
          schools = School.where(district_id: district_id)
        end
        present  schools, with: ::Entities::School
      end

      desc "学校名查学校"
      params do
        requires :q, type: String, desc: "查询标示"
      end
      get '/by_q'do
        schools = School.whrer("name LIKE '%#{params[:q]}%'")
        present schools, with: ::Entities::School
      end
    end

    resources :grade do
      desc "根据学校ID查年级"
      params do
        requires :school_id, type: Integer, desc:"学校ID"
      end
      get 'byschool' do
        shool = School.find(params[:school_id])
        grades = shool.grades
        if grades.empty?
          present :message, "没有找到数据"
        else
          present grades, with: ::Entities::Grade
        end
      end
    end

    resources :team_classes do
      desc "根据学校ID查班级"
      params do
        requires :school_id, type: Integer, desc:"学校ID"
      end
      get 'byschool' do
        shool = School.find(params[:school_id])
        team_classes = shool.team_classes
        if team_classes.blank?
          present :message, "没有找到数据"
        else
          present team_classes, with: ::Entities::TeamClass
        end
      end
    end
  end
end
