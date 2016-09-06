class Bill < ActiveRecord::Base
  before_create :set_order_no

  belongs_to :user
  belongs_to :target_user, class_name: 'User'
  validates  :amount, presence:{ message: "不能为空!"}
  # validates  :order_no,  uniqueness:{ message: "订单号重复!"}

  def complete
    time = 0
    if self.bill_type == 'month'
      time = 1.month
      member_type = 'month'
    else
      time = 1.years
      member_type = 'years'
    end
    puts time
    member = self.target_user.member
    if member.nil?
      puts time
      self.target_user.create_member(
        :start_time  => Time.now,
        :expire_time => Time.now+ time,
        :member_type => member_type
      )
    else
      if Time.now > member.expire_time
        member.update(
          :start_time  => Time.now,
          :expire_time => member.expire_time + time,
          :member_type => member_type
        )
      else
        member.update(
          :expire_time => member.expire_time + time,
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
