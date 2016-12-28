module NewApi
  module V1
    class Students::DynamicsController < Students::BaseController

      def index
        load_student
        dynamics = @student.do_dynamic_works.select(:id, :avatar, :created_at).group_by { |e| e.created_at.strftime("%Y%m") }
        render json:
          dynamics, status: 200, adapter: :json
      end

      def show

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
        return nil unless @student_work # 少年说
        raise StudentWorkHasBeenUploaded if StudentWork.states[@student_work.state] == 1 # block repeat
      end

      def dynamic_params
        params.require(:dynamic).permit(:content, materials_attributes: [:kind, :url])
      end

      def build_dynamic_work(dynamic_params)
        begin
          ActiveRecord::Base.transaction do
            @dynamic = @student.do_works.create!(dynamic_params.merge({type: 'DoDynamicWork', student_work: @student_work}))
            @dynamic.update_columns(avatar: (ENV['QINIUPREFIX'] + dynamic_params[:materials_attributes].first[:url]))
            @student_work.update_columns(state: 1) if @student_work
          end
        rescue => e
          raise DoDynamicWorkNotCreate
        end
      end
    end
  end
end
