module NewApi
  module V1
    class TeamClassesController < BaseController
      before_action :authenticate, only: [:destroy]
      before_action :authenticate_teacher, only: [:destroy]
      before_action :set_team_class, only: [:destroy]

      def index
        render json: {
          test: 'test'
        } if true
      end

      def destroy
        if @team_class
          if @team_class.destroy
            render json: {
              code: 201
            }
          else
            render json: {
              code: 400
            }
          end
        else
          render json: {
            code: 404
          }
        end
      end

      private
      def set_team_class
        @team_class = TeamClass.find_by(id: params[:id])
      end
    end
  end
end

#TODO team_classes 对应一个 班主任
