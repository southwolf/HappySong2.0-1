module NewApi
  module V1
    module Schools
      class ClassesController < BaseController
        before_action :authenticate, only: [:create]
        before_action :set_school, only: [:create]
        before_action :authenticate_teacher, only: [:create]

        # 当前学校所有的班级
        def index
          # @classes = @school.classes
          # render json:
          #   @classes, each_serializer: SchoolSerializer, adapter: :attributes
        end

        def show
        end

        def create
          @class = @school.classes.build(class_params.merge({ teacher_id: current_user.id }))
          if @class.save
            render json:
              @class, serializer: ClassSerializer, status: 201 , adapter: :attributes
          else
            raise RecordNotCreate
          end
        end

        private
        def class_params
          params.require(:class).permit(:name, :grade_no, :class_no)
        end

        def set_school
          @school = Org::School.find_by(id: params[:school_id])
          raise SchoolNotFound unless @school
        end
      end
    end
  end
end
