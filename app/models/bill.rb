class Bill < ActiveRecord::Base
  belongs_to :user
  validates :order_no, :amount, presence:{ message: "不能为空!"}
  validates :order_no,  uniqueness:{ message: "订单号重复!"}
end
