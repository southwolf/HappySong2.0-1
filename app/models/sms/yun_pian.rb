module Sms
  class YunPian
    class << self
      def post(url, options)
        request = Typhoeus::Request.new(url,
          method: :post,
          params: options.merge({
            apikey: "0040f2d02e13f81c5710a92a2d229bdd"
          })
        )
        request.run
      end

      def send(mobile)
        options = {
          mobile: mobile.to_s,
          text: "【欢乐诵】您的验证码是#{load_sms_code(mobile)}。如非本人操作，请忽略本短信[短信验证码一小时内有效]"
        }
        post('https://sms.yunpian.com/v2/sms/single_send.json', options)
      end

      def load_sms_code(mobile)
        user = load_user(mobile)
        sms_code = Sms::Code.find_by(user_id: user.id)
        code = sms_code.code
        sms_code.save unless '18602118683' == mobile
        return code
      end

      def load_user(mobile)
        User.find_or_create_by(phone: mobile)
      end
    end
  end
end
