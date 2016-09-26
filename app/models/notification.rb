class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :actor, class_name: 'User'

  belongs_to :targetable,        polymorphic: true
  belongs_to :second_targetable, polymorphic: true
  belongs_to :third_targetable,  polymorphic: true


  scope :unread, -> { where(unread: true) }

  after_create :push_to_client, on: :create
  def push_to_client
    # if ['comment', 'like', 'follow','reply'].include? self.notice_type
      # puts "#{notify_one}"
      # puts "#{notify_two}"
    # else
    #向对应用户推送消息
    notice_type = self.notice_type
    push_action = PushAction.find_by(action: notice_type)
    #用户不接收notice_type类型的消息
    unless self.user.push_actions.include?(push_action)
      PushToClientJob.perform_later(self.user_id, notice)
    end
    # PushToCilentJob.(user_id, notify)
    #
    # end
  end

  def notice
    {
      notify_one: notify_one,
      notify_id: self.id
    }
  end
  def notify_one
    return "#{self.targetable.content}" if notice_type == 'announce'
    return '' if self.user.blank?
    if notice_type == 'comment'
      "#{self.actor.name}评论了#{user_show}的#{nest_notity}#{self.second_targetable.content}"
    elsif notice_type == 'record'
      "#{self.actor.name}创建了一篇朗读《#{self.targetable.article.title}》"
    elsif notice_type == 'dynamic'
      "#{self.actor.name}发布一篇动态"
    elsif notice_type == 'work'
      "#{self.actor.name}发布了新的朗读作业"
    elsif notice_type == 'complete_work'
      "#{self.actor.name}完成了朗读作业"
    elsif notice_type == 'like'
      "#{self.actor.name}喜欢了#{user_show}的#{nest_notity}"
    elsif notice_type == 'follow'
      "#{self.actor.name}关注了你"
    elsif notice_type == 'reply'
      "#{self.actor.name}回复了#{user_show}的评论#{self.targetable.content}"
    elsif notice_type == 'announce'
       "#{self.targetable.content}"
    else
      'sad'
    end
  end

  def user_show
    self.user.id == self.targetable.id ? "你" : self.targetable.user.name
  end

  def nest_notity
    if self.targetable_type == 'record'
      "朗读"
    elsif self.targetable_type == 'dynamic'
      "动态"
    elsif self.targetable_type == 'work'
      "作业"
    else
      ''
    end
  end
  def self.unread_notify(user)
    self.unread.where(user: user)
  end
end
