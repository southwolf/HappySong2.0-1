# 学生加入班级  退出班级
module NewApi
  module V1
    class Students::ClassesController < Students::BaseController
      before_action :authenticate

      def index
        render json: {
          message: 'test'
        }
      end

      def create
        load_student
        load_class
        ans = @student.join_class(@org_class)
        render_ans(ans)
      end

      def destroy
        load_student
        load_class
        ans = @student.quit_class(@org_class)
        render_ans(ans)
      end

      private
      def load_class
        @org_class = Org::Class.where("code = ? or id = ?", params[:class][:code], params[:id]).first
        raise ClassNotFound unless @org_class
      end

      def render_ans(ans)
        if ans
          return render json: { message: 'success' }, status: 201
        else
          return render json: { message: 'failed' }, status: 400
        end
      end
    end
  end
end
