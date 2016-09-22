namespace :cash_back do
  desc "每月返现"
  task task: :environment do
    User.teacher_users.each do |teacher|
      teacher.invites do |user|
        if user.vip?
          if teacher.has_student?(user)
            #返现5元
            teacher.cash_managers.create(target_user: user, amount: 5)
          else
            #返现3元
            teacher.cash_managers.create(target_user: user, amount: 3)
          end
        else
          #返现为0
          teacher.cash_managers.create(target_user: user)
        end
      end
    end

    #家长积分
    User.parent_users.each do |teacher|

    end
  end

end
