module Channel
  class SchoolController < ChannelAdminController
    before_action :authenticate!
    def new

    end

    def show
      @school = School.find(params[:id])

      @students = Kaminari.paginate_array(@school.students).page(params[:page]).per(10)
    end
  end
end
