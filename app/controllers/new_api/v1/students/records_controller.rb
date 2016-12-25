module NewApi
  module V1
    class Students::RecordsController < Students::BaseController

      def index # 学生查看自己的朗读列表
        load_student
        records = @student.do_works
        # render json:
          # records, each_serializer: Student::WorkSerializer, status: 200, root: 'works', adapter: :json
      end

      def show

      end

      def create
        load_student
        load_student_work
        load_article
        build_record_work(record_params)
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
        return nil unless @student_work
        raise StudentWorkHasBeenUploaded if StudentWork.states[@student_work.state] == 1 # block repeat
      end

      def load_article
        @article = Article.find_by(id: params[:article_id])
      end

      def record_params
        params.require(:record).permit(:content, materials_attributes: [:kind, :url])
      end

      def build_record_work(record_params)
        begin
          ActiveRecord::Base.transaction do
            @record = @student.do_works.create!(record_params.merge({type: 'DoRecordWork', student_work: @student_work}))
            @record.update_columns(avatar: (ENV['QINIUPREFIX'] + @article.cover_img) if @article
            @student_work.update_columns(state: 1) if @student_work
            @record.update_columns(avatar: @student_work.avatar) if @student_work
          end
        rescue => e
          raise DoRecordWorkNotCreate
        end
      end
    end
  end
end
