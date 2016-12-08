# 老师 -> 朗读作业 控制器
module NewApi
  module V1
    class Teachers::RecordsController < Teachers::WorksController
      before_action :authenticate

      def create
        load_teacher
        build_record
      end

      private
      def build_record
        ActiveRecord::Base.transaction do
          @record = RecordWork.create(record_params)
          @record.build_record_work(params[:record][:article_ids], params[:record][:class_ids])
        end
      end

      def record_params
        params.require(:record).permit(:end_time, :start_time, :content)
      end
    end
  end
end
