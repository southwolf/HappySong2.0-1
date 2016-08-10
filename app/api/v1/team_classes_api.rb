module V1
  class TeamClassesApi < Grape::API
    resources :team_classes do
      desc "根据班级码查找对应班级"
      params do
        requires :code, type: String, desc: '班级码'
      end
      get do
        code = params[:code].to_s
        team_class = GradeTeamClass.find_by(code: code)
        if team_class.nil?
          error!("没有找到对应记录,请检查你的班级码是否输入正确", 404)
        else
         present  team_class, with: ::Entities::TeamClass
        end
      end
    end
  end
end
