module NewApi
  module V1
    class OrdersController < BaseController

      before_action :authenticate, only: [:create]
      def create
        order = @current_user.orders.create(order_params)
        charge = order.connect_pingpp
        render json:
          charge, adapter: :attributes, status: 201
      end


      protected
      def order_params
        params.require(:order).permit(:target_user_id, :amount, :bill_type, :channel, :client_ip)
      end
    end
  end
end