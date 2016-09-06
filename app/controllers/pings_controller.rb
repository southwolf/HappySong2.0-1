# encoding: utf-8
class PingsController < ApplicationController

  def test
    respond_to do |format|
      format.json
    end
  end
  # webhooks 回调逻辑处理
  def webhooks
    respond_to do |format|
      puts Pingpp::Webhook.verify?(request)
      puts params['data']['object']['amount']
      if Pingpp::Webhook.verify?(request)
        status =  400
        response_body = ''
        begin
          event = params
          if event['type'].nil?
          elsif event['type'] == 'charge.succeeded'
            # 年费
            if event['data']['object']['amount'] == 10000
              order_no = event['data']['object']['order_no']
              bill = Bill.find(order_no)
              #完成支付
              bill.complete(1.years)
              #月费
            elsif event['data']['object']['amounts'] == 10
              order_no = event['data']['object']['order_no']
              bill = Bill.find(order_no)
              bill.complete(1.month)
            end
            status = 200
            response_body = 'OK'
          else
            response_body = '未知类型'
          end
        rescue JSON::ParserError
          response_body = 'JSON解析失败'
        end

        response.body = response_body
        request['Content-Type'] = 'text/plain; charset=utf-8'
        response.status = status
      else
        response.status = 403
      end
      render json: { code: 0, message: "OK"} 
    end
  end
end
