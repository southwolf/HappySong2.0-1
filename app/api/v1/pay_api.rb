module V1
  class Pay < Grape::API
    namespace :pay do
      desc "支付接口"
      params do
        requires :channel, type: String, desc: "渠道类型"
        requires :amount,  type: Integer, desc: "支付金额"
        requires :client_ip, type: String, desc: "客户端IP"
      end

      post 'pay' do
        # channel  = params[:channel]
        # amount   = params[:amount]
        # currency = "cny"
        # subject  = "【欢乐诵】会员充值"
        # body     = "欢乐诵会员"
      end
    end
  end
end
