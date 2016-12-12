# 老师 -> 创作作业 控制器
module NewApi
  module V1
    class Teachers::DynamicsController < Teachers::WorksController

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
