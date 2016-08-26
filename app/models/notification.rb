class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :targetable, polymorphic: true

  scope :unread, -> { where(unread: true) }

  after_create :push_to_client, on: :create
  def push_to_client
    if ['comment', 'like', 'follow'].include? self.notification_type
      puts "#{notify_one}"
      puts "#{notify_two}"
    else
      puts "#{notify_one}"
    end
  end

  def notify_one
    return "#{self.targetable.content}" if notification_type == 'announce'
    return '' if self.user.blank?
    if notification_type == 'comment'
      "#{self.user.name}评论了#{self.targetable.user.name}的#{nest_notity}"
    elsif notification_type == 'record'
      "#{self.user.name}创建了一篇朗读《#{self.targetable.article.title}》"
    elsif notification_type == 'dynamic'
      "#{self.user.name}发布一篇动态"
    elsif notification_type == 'work'
      "#{self.user.name}发布了新的朗读作业"
    elsif notification_type == 'like'
      "#{self.user.name}喜欢了#{self.targetable.user.name}的#{nest_notity}"
    elsif notification_type == 'follow'
      "#{self.user.name}关注了#{self.targetable.name}"
    else
      ' '
    end
  end
 
  def notify_two
    return '' if self.user.blank?
    if notification_type == 'comment'
      "#{self.user.name}评论了你的#{nest_notity}"
    elsif notification_type == 'like'
      "#{self.user.name}喜欢了你的#{nest_notity}"
    elsif notification_type == 'follow'
      "#{self.user.name}关注了你"
    else
      ""
    end
  end
  def nest_notity
    if self.targetable_type == 'Record'
      "朗读"
    elsif self.targetable_type == 'Dynamic'
      "动态"
    elsif self.targetable_type == 'Work'
      "作业"
    else
      ''
    end
  end
end
