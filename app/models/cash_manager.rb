class CashManager < ActiveRecord::Base
  belongs_to :user
  belongs_to :target_user, class_name:"User"

  after_commit :update_cash_back

  def update_cash_back
    return if self.amount == 0
    cash_back = CashBack.find_or_create_by(user: self.user)
    cash_back.update(cash: self.amount)
  end
end
