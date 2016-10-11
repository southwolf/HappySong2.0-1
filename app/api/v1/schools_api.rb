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
          schools = School.verify_school
        else
          schools = School.verify_school.where(district_id: district_id)
        end
        present  schools, with: ::Entities::School
      end

      desc "学校名查学校"
      params do
        requires :q, type: String, desc: "查询标示"
      end
      get '/by_q'do
        schools = School.verify_school.where("name LIKE '%#{params[:q]}%'")
        present schools, with: ::Entities::School
      end

      desc "申报学校"
      params do
        requires :auth_token, type: String,   desc: "token"
        requires :name,       type: String,   desc:"学校名称"
        requires :district_id, type: Integer, desc:"区ID"
      end

      post '/report_school' do
        authenticate!
        name = params[:name]
        district_id = params[:district_id]
        if Scholl.where(district_id: district_id,name: name).blank?
          school = current_user.schools.new(district_id: district_id, name: name, verify: false)
          if school.save
            present :message, "申报成功"
          else
            present :message, "申报失败，请重试"
          end
        else
          present :message, "学校已经存在！"
        end

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
        present grades, with: ::Entities::Grade
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
        present team_classes, with: ::Entities::TeamClass
      end
    end
  end
end
