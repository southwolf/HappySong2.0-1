module NewApi
  module V1
    class Pingpp::WebhooksController < BaseController
      def create
        case params['type']
        when "charge.succeeded" # 改变 order 状态 | 添加 会员
          charge_id = params['data']['object']['id']
          order = Order.find_by(charge_id: charge_id)
          if order
            order.update_attribute('complete', true)
            return render json: { }, status: 201
          else
            return render json: { }, status: 500
          end
        end
      end
    end
  end
end
