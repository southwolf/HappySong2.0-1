# 老师 -> 朗读作业 控制器
module NewApi
  module V1
    class Teachers::RecordsController < Teachers::WorksController

      skip_before_action :authenticate, only: [:index]

      def index #当前老师布置的所有朗读作业
        load_teacher
        @record_works = @teacher.record_works.group_by { |e| e.created_at.strftime("%Y%m") }
        render json: {
          record_works: @record_works
        }, status: 200
      end

      def create
        load_teacher
        ans = build_record
        return render json: { message: 'Success' }, status: 201 if ans
      end

      private
      def build_record
        ActiveRecord::Base.transaction do
          if (params[:record][:article_ids] && params[:record][:class_ids])
            @record = RecordWork.create(record_params.merge({ teacher_id: params[:teacher_id] }))
          else
            return raise RecordWorkNotCreate
          end
          @record.build_record_work(params[:record][:article_ids], params[:record][:class_ids])
        end
      end

      def record_params
        params.require(:record).permit(:end_time, :start_time, :content)
      end
    end
  end
end
