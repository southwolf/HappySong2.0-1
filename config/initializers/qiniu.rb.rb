require 'qiniu'

Qiniu.establish_connection! :access_key => "XPkz9WOVTkbyYtb8-VLEeWmberJ9Rclmp33Xnox4",
                            :secret_key => "1WV7QWH2P9VMBVn3GaiQJBcJgWvZJoBFvdHEyZkF"

base_url = YAML.load_file("#{Rails.root}/config/base_url.yml")[Rails.env]

ENV['QINIUPREFIX']='http://7xpl2d.com1.z0.glb.clouddn.com/'
ENV['apikey']='0040f2d02e13f81c5710a92a2d229bdd'
ENV['base_url']='https://sms.yunpian.com/v2/'
ENV['SHARERECORD']=base_url['shared_url']
