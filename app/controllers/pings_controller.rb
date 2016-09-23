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
          puts "fuck"
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
            bill.complete
            target_invite = bill.target_user.target_invite
            
            #如果此用户是被邀请注册的
            if target_invite.present?
              target_invite.cash_back_count += 12
              target_invite.save
            end

            #月费
          elsif event['data']['object']['amount'] == 100
            puts "月费"
            order_no = event['data']['object']['order_no']
            bill = Bill.find_by(order_no: order_no)
            # bill.update(:complete => true)
            bill.complete
            target_invite = bill.target_user.target_invite
            #如果此用户是被邀请注册的
            if target_invite.present?
              target_invite.cash_back_count += 1
              target_invite.save
            end
          else
            puts "支付失败"
          end
          status = 200
          response_body = 'OK'

        else
          response_body = '未知类型'
        end
        # rescue JSON::ParserError
          # response_body = 'JSON解析失败'
        # end

        response.body = response_body
        request['Content-Type'] = 'text/plain; charset=utf-8'
        response.status = status
      else
        response.status = 403
      end
      format.json { render json: { message: "code"}}
    end
  end
end
