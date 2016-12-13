# 老师 -> 创作作业 控制器
module NewApi
  module V1
    class Teachers::DynamicsController < Teachers::WorksController

      skip_before_action :authenticate, only: [:index, :month]

      def index
        load_teacher
        @dynamic_works = @teacher.dynamic_works.select(:id, :avatar, :created_at).group_by { |e| e.created_at.strftime("%Y%m") }
        render json: {
          dynamic_works: @dynamic_works
        }, status: 200
      end

      def month
        load_teacher
        @dynamic_works = @teacher.dynamic_works.select(:id, :avatar, :created_at).where("date_format(created_at, '%Y%m') = ?", params[:month])
        render json: {
          record_works: @dynamic_works
        }, status: 200
      end

      def create
        load_teacher
        ans = build_dynamic
        return render json: { message: 'Success' }, status: 201 if ans
      end

      private
      def build_dynamic
        ActiveRecord::Base.transaction do
          if (params[:dynamic][:files] && params[:dynamic][:class_ids])
            @dynamic = DynamicWork.create(dynamic_params.merge({ teacher_id: params[:teacher_id] }))
          else
            return raise DynamicWorkNotCreate
          end
          @dynamic.build_dynamic_work(params[:dynamic][:files], params[:dynamic][:class_ids])
        end
      end

      def dynamic_params
        params.require(:dynamic).permit(:end_time, :start_time, :content)
      end
    end
  end
end
