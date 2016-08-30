module V1
  class Pay < Grape::API
    namespace :pay do
      desc "支付接口"
      params do
        requires :channel,        type: String,  desc: "渠道类型"
        requires :amount,         type: Integer, desc: "支付金额"
        requires :client_ip,      type: String,  desc: "客户端IP"
        requires :token,          type: Integer, desc: "用户访问令牌"
        optional :target_user_id, type: Integer, desc: "目标ID"
      end

      post 'pay' do
        channel   = params[:channel]
        amount    = params[:amount]
        client_ip = params[:client_ip]
        currency  = "cny"
        subject   = "【欢乐诵】会员充值"
        body      = "欢乐诵会员"
        order_no  = set_order_no
        res_body = ''
        if amount == 100
          bill_type = "years"
        else
          bill_type = "month"
        end
        begin
          res = Pingpp::Charge.create(
            :order_no  => order_no,
            :app       => { :id => 'app_yT48q5PWfLyL8qvj'},
            :channel   => channel,
            :amount    => amount*100,
            :client_ip => client_ip,
            :currency  => currency,
            :subject   => subject,
            :body      => body
          )
          current_user.create_bill(
             :target_user => current_user.id,
             :amount      => amount,
             :bill_type   => bill_type
          )
          res_body = ActiveSupport::JSON.decode res
        rescue Pingpp::PingppError => error
          res_body = error.http_body
        end

        present :result, res_body
      end
    end
  end
end
