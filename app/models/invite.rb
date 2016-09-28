class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :target_user, class_name: 'User'

  after_action :inset_data, only: [:create]

  def inset_data
    if self.user.try(:role).try(:name) == 'teacher'
      self.user.cash_managers.create(target_user: self.target_user)
    else
    end

  end

end
