class CreditManager < ActiveRecord::Base
  belongs_to :user
  belongs_to :target_user, class_name:"User"
  # 更新返现的积分
  after_commit :update_credit

  def update_credit
    return if self.point == 0
    Credit.transaction do
      credit = Credit.find_or_create_by(user: self.user)
      credit.point += self.point
      credit.save!
    end
  end
end
