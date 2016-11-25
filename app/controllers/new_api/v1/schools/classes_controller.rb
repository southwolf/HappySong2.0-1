module NewApi
  module V1
    module Schools
      class ClassesController < BaseController
        before_action :authenticate, only: [:create]
        before_action :set_school, only: [:create]

        # 当前学校所有的班级
        def index
          @classes = @school.classes
          render json:
            @classes, each_serializer: SchoolSerializer, adapter: :attributes
        end

        def show
        end

        def create

        end

        private
        def class_params
          params.require(:class).permit(:name)
        end

        def set_school
          @school = School.find_by(id: params[:school_id])
          return render json: {
            error: '未找到学校'
          } unless @school
        end
      end
    end
  end
end
