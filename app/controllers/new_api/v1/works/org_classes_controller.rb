module NewApi
  module V1
    class Works::OrgClassesController < Works::BaseController
      before_action :authenticate
      skip_before_action :load_class

      def index
        # org_classes = Org::Class.where(id: ClassWork.where(work_id: params[:work_id]).pluck(:class_id).uniq)
        org_classes = current_user.classes.joins(:works).merge(HomeWork.where(id: params[:work_id]))
        # render json: {
        #   classes: org_classes
        # }, status: 200
        render json:
          org_classes, each_serializer: ClassSerializer, status: 200, root: "classes", adapter: :json
      end

    end
  end
end
