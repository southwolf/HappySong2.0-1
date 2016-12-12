class NewNotification < ApplicationRecord

  # associations
  belongs_to :actor, class_name: 'User', foreign_key: :actor_id
  belongs_to :targetable, polymorphic: true # 评论 | 朗读 | 少年说 | 作业

  # callbacks
  after_commit :notify_users, on: :create
  def notify_users # 这段逻辑要放在 ActiveJob 里面处理
    payload = Jpush::Payload.new(user_ids, build_message).pay
    Jpush::Client.notify(payload)
  end

  private
  def build_message
    case index
    when 1
      "#{actor.try(:name) }老师给你布置了新的作业咯"
    when 2
    end
  end

  def user_ids
    case index
    when 1
      ['108']
    when 2
    else
    end
  end

  def relative_class_students # 布置作业的时候 actor<老师> targetable<作业>
    # binding.pry
  end

end


# 1: xxx 老师给你布置了新的作业咯       -> 班级相关的学生收到推送     index
# 2: xxx 发布新的 少年说|朗读 了, 快去看看  -> 关注 xxx 的人收到推送

# 3: xxx 关注了你
# 4: xxx 赞了你的 少年说 | 朗诵 | 评论
# 5: xxx 评论了你的 少年说 | 朗诵
# 6: xxx 回复了你的 评论
