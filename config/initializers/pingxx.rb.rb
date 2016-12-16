require "pingpp"
if Rails.env == 'production'
  Pingpp.api_key = "sk_live_a9qjX5i1u5CO9i1Wv5KiX5uL"
  Pingpp.app_id = 'app_yT48q5PWfLyL8qvj'
else
  Pingpp.api_key = 'sk_test_SKmjH4SGW5uHiTqjPKS0aT04'
  Pingpp.app_id = 'app_yT48q5PWfLyL8qvj'
end

Pingpp.private_key_path = File.dirname(__FILE__)+"/pingpp_rsa_private_key.pem"
Pingpp.pub_key_path = File.dirname(__FILE__)+"/pingpp_rsa_public_key.pem"
