class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :target_user, class_name: 'User'

  after_action :inset_data, only: [:create]

  def inset_data
    if self.user.try(:role).try(:name) == 'teacher'
      #如果推荐人是教师则给老师的返现记录添加一条但是金额为0,仅仅为了客户端显示
      self.user.cash_managers.create(target_user: self.target_user)
    elsif self.user.try(:role).try(:name) == 'parent'
    end

  end

end
