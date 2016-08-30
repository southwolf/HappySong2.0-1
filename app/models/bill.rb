class Bill < ActiveRecord::Base
  belongs_to :user
  has_one    :target_user
  validates :order_no, :amount, presence:{ message: "不能为空!"}
  validates :order_no,  uniqueness:{ message: "订单号重复!"}


  def complete( expire_time)
    self.complete = true
    self.save
    if expire_time == 30
      member_type = 'month'
    else
      member_type = 'years'
    end
    member = self.target_user.member
    if member.empty?
      self.target_user.create_member(
        :start_time  => Time.now,
        :expire_time => Time.now+expire_time.day,
        :member_type => member_type
      )
    else
      member.update(
        :start_time  => Time.now,
        :expire_time => Time.now + expire_time.day,
        :member_type => member_type
      )
    end

  end

  def set_order_no
    loop do
      self.order_no = ([*?a..?z]+[*?0..?9]).sample(30).join
    break if  Bill.where(:order_no => order_no).empty?
    end    
  end
end
