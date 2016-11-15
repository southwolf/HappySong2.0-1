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
        # begin
        event = params
        puts  "begin"
        if event['type'].nil?
          response_body = "type异常"
        elsif event['type'] == 'charge.succeeded'
          # 年费
          #
          puts "成功"
          puts  event['data']['object']['amount']
          if event['data']['object']['amount'] == 10000
            puts "年费"
            order_no = event['data']['object']['order_no']
            bill = Bill.find_by(order_no: order_no)
            # bill.update(:complete => true)
            #完成支付
            if bill.complete_bill?
              #成功就向推荐用户加n个返现计数
              invite = bill.target_user.one_invite
              return if invite.nil?
              invite.cash_back_count += 12
              invite.save
              response_body = "OK"
            else
              response_body = "失败"
            end
            #月费
          elsif event['data']['object']['amount'] == 1000
            puts "月费"
            order_no = event['data']['object']['order_no']
            bill = Bill.find_by(order_no: order_no)
            # bill.update(:complete => true)
            if bill.complete_bill?
              invite = bill.target_user.one_invite
              return if invite.nil?
              invite.cash_back_count += 1
              invite.save
            end
          else
            response_body =  "支付失败"
          end
          status = 200
        else
          response_body = '未知类型'
        end
        # rescue JSON::ParserError
          # response_body = 'JSON解析失败'
        # end

        response.body = response_body
        request['Content-Type'] = 'text/plain; charset=utf-8'
        response.status = status
        format.json { render json: { message: response_body}}
      else
        response.status = 403
        format.json { render json: { message: "失败"}}
      end
    end
  end
end
