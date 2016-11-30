module NewApi
  module V1
    module Teachers
      class ProfilesController < BaseController
        def index
          load_teacher
          render json:
            @teacher, serializer: Teacher::ProfileSerializer, status: 200, root: "prfile", adapter: :json
        end
      end
    end
  end
end
