# 老师 -> 个人中心
module NewApi
  module V1
    class Teachers::ProfileController < Teachers::BaseController
      def index
        load_teacher
        render json:
          @teacher, serializer: Teacher::ProfileSerializer, status: 200, root: "profile", adapter: :json
      end
    end
  end
end
