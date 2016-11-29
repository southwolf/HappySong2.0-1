namespace :sms_code do
  desc "每个用户都生成一个现有的验证码"
  task :init => :environment do
    User.find_each do |user|
      sms_code = Sms::Code.new(user_id: user.id)
      sms_code.save!
    end
  end
end
