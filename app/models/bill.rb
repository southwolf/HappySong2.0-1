class Bill < ActiveRecord::Base
  before_create :set_order_no

  belongs_to :user
  belongs_to :target_user, class_name: 'User'
  validates  :amount, presence:{ message: "不能为空!"}
  # validates  :order_no,  uniqueness:{ message: "订单号重复!"}

  def complete(time)
    self.complete = true
    self.save
    if time == 30
      member_type = 'month'
    else
      member_type = 'years'
    end
    member = self.target_user.member
    if member.empty?
      self.target_user.create_member(
        :start_time  => Time.now,
        :expire_time => expire_time + time,
        :member_type => member_type
      )
    else
      if Time.now > expire_time
        member.update(
          :start_time  => Time.now,
          :expire_time => expire_time + time,
          :member_type => member_type
        )
      else
        member.update(
          :expire_time => expire_time + time,
          :member_type => member_type
        )
      end
    end

  end
private
  def set_order_no
    loop do
      self.order_no = ([*?a..?z]+[*?0..?9]).sample(30).join
    break if  Bill.where(:order_no => order_no).empty?
    end
  end
end
