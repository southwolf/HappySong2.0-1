  namespace :cash_back do
  desc "每月返现"
  task task: :environment do
    #如果是月末
    if Time.now.day == Time.now.end_of_month.day
      User.teacher_users.each do |teacher|
        teacher.invites do |invites|
          if invites.cash_back_count != 0
            if invites.is_student == 1
              teacher.cash_managers.create(target_user: invites.target_user, amount: 3)
              invites.cash_back_count -= 1
              invites.save
            else
              teacher.cash_managers.create(target_user: invites.target_user, amount: 2)
              invites.cash_back_count -= 1
              invites.save
            end
          else
            teacher.cash_managers.create(target_user: invites.target_user, amount: 0)
          end
        end
      end

      #家长积分
      User.parent_users.each do |teacher|
    end
    end
  end

end
