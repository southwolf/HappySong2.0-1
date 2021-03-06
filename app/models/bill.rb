class Bill < ActiveRecord::Base
  #订单
  before_create :set_order_no

  belongs_to :user
  belongs_to :target_user, class_name: 'User'
  validates  :amount, presence:{ message: "不能为空!"}
  # validates  :order_no,  uniqueness:{ message: "订单号重复!"}

  def complete_bill?
    self.update_attribute(:complete, true)
    # puts "成功"
    # time = 0
    if self.bill_type == 'month'
      time = 31.days
      member_type = 'month'
    else
      time = 1.years
      member_type = 'years'
    end

    # puts time
    member = self.target_user.member
    if member.nil?
      # puts time
      # puts member_type
      self.target_user.create_member(
        :start_time  => Time.now.to_i,
        :expire_time => Time.now.to_i + time,
        :member_type => member_type
      )
      return true
    else
      if Time.now.to_i > member.expire_time
        # puts member_type
        member.update(
          :start_time  => Time.now.to_i,
          :expire_time => member.expire_time + time,
          :member_type => member_type
        )
        return true
      else
        # puts member_type
        member.update(
          :expire_time => member.expire_time + time,
          :member_type => member_type
        )
        return true
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
