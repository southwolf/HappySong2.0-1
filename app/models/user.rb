class User < ActiveRecord::Base

  class << self
    def current
      Thread.current[:user]
    end
    def current=(user)
      Thread.current[:user] = user
    end
  end

  before_create :create_auth_token, :create_code, :create_uid

  # after_create :add_a_month_vip
  validates :phone, uniqueness: true
  validates :phone, :avatar, presence: true

  belongs_to :role

  scope :teacher_users,   ->{ where(role_id: 1)}
  scope :parent_users,    ->{ where(role_id: 2)}
  #建议
  has_many   :advises,               dependent: :destroy
  has_many   :relationships,         foreign_key: 'follower_id',
                                     dependent: :destroy
  has_many   :reverse_relationships, class_name: "Relationship",
                                     foreign_key: 'following_id',
                                     dependent: :destroy
  has_many   :followings,    :through => :relationships
  has_many   :followers,     :through => :reverse_relationships

  has_many   :grade_team_classes, foreign_key: 'teacher_id', dependent: :destroy
  belongs_to :grade_team_class

  #评论
  has_many   :comments,      dependent: :destroy
  # 相册
  has_many   :albums,        dependent: :destroy

  has_many   :records,       dependent: :destroy
  has_many   :likes,         foreign_key: 'like_user_id', dependent: :destroy
  has_many   :like_records,  through: :likes, source: :likeable, source_type: 'Record'
  has_many   :like_dynamics, through: :likes, source: :likeable, source_type: 'Dynamic'

  has_many   :dynamics,      dependent: :destroy

  # 浏览
  has_many   :views,        foreign_key: 'viewer_id', dependent: :destroy
  has_many   :view_records, through: :views

  # 积分
  has_one    :credit,      dependent: :destroy
  has_many   :credit_managers, dependent: :destroy

  #返现
  has_one    :cash_back,     dependent: :destroy
  has_many   :cash_managers, dependent: :destroy

  #申请提现
  has_many   :withdraw_cashes, dependent: :destroy
  # 举报
  has_many   :reports, dependent: :destroy

  # 子女
  has_many   :children, class_name: 'User',
                        foreign_key: 'parent_id', dependent: :nullify

  belongs_to :parent,   class_name: 'User'

  #会员
  has_one    :member, dependent: :destroy

  # has_many   :own_notifications, class_name: 'Notification', foreign_key: 'actor_id'
  # has_many   :notifications,     as: :targetable

  # 账单
  has_many   :bills, dependent: :destroy
  has_one    :target_bill, foreign_key: :target_user_id, class_name:'Bill'

  #我推荐的人的集合
  has_many   :invites
  has_many   :target_invite_users, through: :invites, class_name: 'User'

  #推荐我的人
  has_one    :one_invite,  class_name: 'Invite', foreign_key: 'target_user_id'
  has_one    :invite_user, through: :one_invite, class_name: 'User'

  #推送通知设置
  has_many   :notify_configs, dependent: :destroy
  has_many   :push_actions, through: :notify_configs


  has_many   :works

  has_many   :work_to_students, foreign_key: "student_id", dependent: :destroy
  has_many   :my_works, class_name: "Work",
                        through: :work_to_students

  after_destroy :delete_all_notifiaction
  # has_sms_verification
  scope :students, ->{where(role_id: 1)}


  def record_work(work_id)
    records.where(work_id: work_id)
  end

  def creative_work(work_id)
    dynamics.where(work_id: work_id)
  end

  def add_a_month_vip
    if self.try(:role).try(:name) == 'student'
      start_time  = Time.now.to_i
      expire_time = (Time.now + 31.day).to_i
      Member.create(user: self, member_type: 'month',
                    start_time: start_time, expire_time: expire_time)
    end
  end

  def delete_all_notifiaction
    Notification.where(user: self).destroy_all
    Notification.where(actor: self).destroy_all
  end

  def reset_auth_token!
    create_auth_token
    save
  end
  # 生成token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 加密token
  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # 是否关注
  def followed?(user)
    followings.include?(user)
  end

  # 关注用户
  def follow(user)
    return false if user.blank?
    followings << user
    # relationships.create(following_id: user.id)
  end

  # 取消关注
  def unfollow(user)
    return false if user.blank?
    followings.destroy user
    # relationships.find_by( following_id: user.id).destroy
  end

  # 我关注的人的集合
  def following_users
    User.where(id: self.following_ids)
  end

  # 关注我的人的集合
  def follower_users
    User.where(id: self.follower_ids)
  end

  # 我的同学【学生】
  def classmates
    grade_team_class = self.grade_team_class
    return [] if grade_team_class.nil?
    grade_team_class.students.reject { |student| student == self  }
  end

  def show_phone
    "#{self.phone.slice(0..2)}****#{self.phone.slice(-4..-1)}"
  end


  def has_student?(student)
    return false if self.grade_team_classes.blank?
    self.grade_team_classes.each do |grade_team_class|
      if grade_team_class.students.include?(student)
        return true
      end
    end
    return false
  end

  def can_inviter?
    students = 0
    vip      = 0
    self.grade_team_classes.each do |grade_team_class|
      students += grade_team_class.user_count
      vip      += grade_team_class.vip_count
    end
    #如果没有学生不能分享
    return false if students == 0
    if vip.quo(students) >= (1/2)
      return true
    else
      return false
    end

  end
  # 设置为会员
  def add_vip( day)
    if self.member.nil?
      if day == 30
        type = "mon"
      elsif day == 365
        type = "year"
      else
        type = "free"
      end
      self.create_member(:start_time => Time.now,
                         :expire_time => Time.now + day.day,
                         :member_type => type)
    else
      self.member.update(:expire_time => Time.now + day.day)
    end
  end


  # 添加角色
  def add_role name
    role = Role.find_by_name(name)
    if role.nil?
      self.create_role(:name => name)
    else
      self.role = role
      self.save
    end
  end

  #停止接受消息
  def add_push_action(*push_actions)
    push_actions.each do |push_action|
      return if self.push_actions.include?(push_action)
      self.push_actions << push_action
    end
    return true
  end
  #开启接受消息
  def remove_push_action(*push_actions)
    push_actions.each do |push_action|
      return unless self.push_actions.include?(push_action)
      self.push_actions.destroy(push_action)
    end
    return true
  end
  # 判断是否有对应角色
  def has_role? name
    role.try(:name) == name
  end

  # 设置角色
  def set_role(role_id)
    case role_id
    when 0
      self.add_role 'teacher'
    when 1
      self.add_role 'parent'
    when 2
      self.add_role 'student'
    else
      return false
    end
  end

  private
  def create_auth_token
    loop do
      self.auth_token = User.encrypt(User.new_token)
      break if User.where(auth_token: auth_token).empty?
    end
  end

  def create_code
    loop do
      self.code = ([*?a..?z]+[*?1..?9]).sample(4).join
      break if User.where(code: code).empty?
    end
  end

  def create_uid
    loop do
      self.uid = ([*?a..?z]+[*?1..?9]).sample(8).join
      break if User.where(uid: uid).empty?
    end
  end
end
