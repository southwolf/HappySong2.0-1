module V1
  class Pay < Grape::API
    namespace :pay do
      desc "支付接口"
      params do
        requires :channel, type: String, desc: "渠道类型"
        requires :amount,  type: String, desc: "zhifu"
      end
    end
  end
end
