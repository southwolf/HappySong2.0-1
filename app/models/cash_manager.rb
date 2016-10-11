class CashManager < ActiveRecord::Base
  belongs_to :user
  belongs_to :target_user, class_name:"User"

# 更新返现的金额
  after_commit :update_cash_back

  def update_cash_back
    return if self.amount == 0
    CashBack.transaction do
      cash_back = CashBack.find_or_create_by(user: self.user)
      cash_back.cash += self.amount
      cash_back.save!
    end
  end
end
