class PingsController < ApplicationController
 
  # webhooks 回调逻辑处理
  def webhooks
    if Pingpp::Webhook.verify?(request)
      status =  400
      response_body = ''
      begin
        event = JSON.parse(request.body)
        if event['type'].nil?
        elsif event['type'] == 'charge.succeeded'
          # 年费
          if event['data']['object']['amounts'] == 10000
            order_no = event['data']['object']['order_no']
            bill = Bill.find(order_no)
            #完成支付
            bill.complete(365)
          #月费
          elsif event['data']['object']['amounts'] == 1000
             order_no = event['data']['object']['order_no']
             bill = Bill.find(order_no)

             bill.complete(30)
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
  end
end
