# encoding: utf-8

SmartSMS.configure do |config|
  config.api_key = 'e942a1f1186f568a630db7912c3dd76e'
 config.api_version = :v1
 # config.template_id = '2'
 # config.template_value = [:code, :company]
 config.page_num = 1
 config.page_size = 20
 config.company = '云片网'
 config.expires_in = 1.hour
 config.default_interval = 1.day
 config.store_sms_in_local = true
 config.verification_code_algorithm = :short
end
