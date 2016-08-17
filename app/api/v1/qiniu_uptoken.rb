module V1
  class QiniuUptoken < Grape::API
    require 'qiniu'

    resources :qiniu_uptoken do
      desc '七牛的uptoken、'

      get do
        put_policy = ::Qiniu::Auth::PutPolicy.new(
          'happysong',
          3600
        )
        uptoken = ::Qiniu::Auth.generate_uptoken( put_policy )
        present :uptoken, uptoken
      end
    end
  end
end
