  namespace :cash_back do
  desc "每月返现"
  task task: :environment do
    #如果是月末
    if Time.now.day == Time.now.end_of_month.day
      User.teacher_users.each do |teacher|
        teacher.invites.each do |invite|

          #查看是否已经有相同月份返现数据[只要邀请成功就添加一条返现不过金额为0，用来在手机端显示]
          result = teacher.cash_managers.where(target_user: invite.target_user)
                          .select { |e| e.created_at.strftime("%Y-%m") == Time.now.strftime("%Y-%m")}.first

          if invite.cash_back_count != 0
            if invite.is_student == 1
              unless result.nil?
                result.update(amount: 3)
              else
                teacher.cash_managers.create(target_user: invite.target_user, amount: 3)
              end
              invite.cash_back_count -= 1
              invite.save
            else
              unless result.nil?
                result.update(amount: 2)
              else
                teacher.cash_managers.create(target_user: invite.target_user, amount: 2)
              end
              invite.cash_back_count -= 1
              invite.save
            end
          else
            teacher.cash_managers.create(target_user: invite.target_user, amount: 0) if result.nil?
          end
        end
      end

      #家长积分
      User.parent_users.each do |parent|
        parent.invites.each do |invite|
          result = parent.credit_managers.where(target_user: invite.target_user)
                          .select { |e| e.created_at.strftime("%Y-%m") == Time.now.strftime("%Y-%m")}.first
          #符合返现条件
          if invite.cash_back_count != 0
            unless  result.nil?
              result.update(point: 1000)
            else
              parent.credit_managers.create(target_user: invite.target_user, point: 100)
            end
          else
            #不符合返现条件
            parent.credit_managers.create(target_user: invite.target_user, point: 0) if result.nil?
          end
        end
      end
    end

  end
end
