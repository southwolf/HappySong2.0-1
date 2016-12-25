module NewApi
  module V1
    class Students::DynamicsController < Students::BaseController

      def index # 学生查看自己的创作列表
        load_student
        works = @student.student_works
        render json:
          works, each_serializer: Student::WorkSerializer, status: 200, root: 'works', adapter: :json
      end

      def create
        load_student
        load_student_work
        build_dynamic_work(dynamic_params)
        render json: {
          message: 'success',
        }, status: 201
      end

      def destroy
      end

      protected

      def load_student
        @student = Student.includes(:do_works).find_by(id: params[:student_id])
        raise StudentNotFound unless @student
      end

      def load_student_work
        @student_work = @student.student_works.find_by(work_id: params[:work_id])
        raise StudentWorkNotFound unless @student_work
        raise StudentWorkHasBeenUploaded if StudentWork.states[@student_work.state] == 1 # block repeat
      end

      def dynamic_params
        params.require(:dynamic).permit(:content, materials_attributes: [:kind, :url])
      end

      def build_dynamic_work(dynamic_params)
        begin
          @dynamic = @student.do_works.create!(dynamic_params.merge({type: 'DoDynamicWork', student_work: @student_work}))
          @student_work.update_columns(state: 1)
        rescue => e
          raise DoDynamicWorkNotCreate
        end
      end
    end
  end
end
