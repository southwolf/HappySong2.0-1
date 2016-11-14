# encoding: utf-8
module V1
  class Pay < Grape::API
    use ActionDispatch::RemoteIp

    namespace :pay do

      desc "支付接口"
      params do
        requires :channel,        type: String,  desc: "渠道类型"
        requires :amount,         type: Integer, desc: "支付金额"
        requires :client_ip,      type: String,  desc: "客户端IP"
        requires :token,          type: String,  desc: "用户访问令牌"
        optional :target_user_id, type: Integer, desc: "目标ID"
      end

      post 'pay' do
        authenticate!
        channel   = params[:channel]
        amount    = params[:amount]
        client_ip = params[:client_ip].to_s || client_ip()
        target_user_id = params[:target_user_id] || current_user.id
        if amount == 100
          bill_type = "years"
        else
          bill_type = "month"
        end
        bill = current_user.bills.create(
           :target_user_id => target_user_id,
           :amount      => amount,
           :bill_type   => bill_type,
           :channel     => channel,
           :client_ip   => client_ip
        )
        begin
          currency  = "cny"
          subject   = "【欢乐诵】充值"
          body      = "【欢乐诵】会员充值"

          charge = Pingpp::Charge.create(
            :order_no  => bill.order_no,
            :app       => { :id => 'app_yT48q5PWfLyL8qvj'},
            :channel   => bill.channel,
            :amount    => amount * 100,
            :client_ip => bill.client_ip,
            :currency  => currency,
            :subject   => subject,
            :body      => body
          )
          present charge
        rescue Pingpp::PingppError => error
            error!({error: error}, 500)
        end
      end


      desc "Web支付接口"
      params do
        requires :channel,        type: String,  desc: "渠道类型"
        requires :amount,         type: Integer, desc: "支付金额"
        requires :token,          type: String,  desc: "用户访问令牌"
        optional :target_user_id, type: Integer, desc: "目标ID"
      end

      post '/web_pay' do
        authenticate!
        channel   = params[:channel]
        amount    = params[:amount]
        client_ip = client_ip()
        target_user_id = params[:target_user_id] || current_user.id
        if amount == 100
          bill_type = "years"
        else
          bill_type = "month"
        end
        case channel
        when "alipay_wap"
          extra = {
            # success_url 和 cancel_url 在本地测试不要写 localhost ，请写 127.0.0.1。URL 后面不要加自定义参数
            :app_pay     => true,
            :success_url => "http://abc.happysong.com.cn/web_pay/success",
            :cancel_url  => "http://abc.happysong.com.cn/web_pay/cancel"

          }
        end
        bill = current_user.bills.create(
           :target_user_id => target_user_id,
           :amount      => amount,
           :bill_type   => bill_type,
           :channel     => channel,
           :client_ip   => client_ip,
        )
        begin
          currency  = "cny"
          subject   = "【欢乐诵】充值"
          body      = "【欢乐诵】会员充值"

          charge = Pingpp::Charge.create(
            :order_no  => bill.order_no,
            :app       => { :id => 'app_yT48q5PWfLyL8qvj'},
            :channel   => bill.channel,
            :amount    => amount * 100,
            :client_ip => bill.client_ip,
            :currency  => currency,
            :subject   => subject,
            :body      => body,
            :extra     => extra
          )
          present charge
        rescue Pingpp::PingppError => error
            error!({error: error}, 500)
        end
      end
    end
  end
end
