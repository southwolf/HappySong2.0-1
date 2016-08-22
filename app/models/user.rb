class User < ActiveRecord::Base

  before_create :create_auth_token, :set_code, :set_id_code
  validates :phone, uniqueness: true
  validates :phone, :avatar, presence: true

  belongs_to :role
  has_many   :advises
  has_many   :relationships,         foreign_key: 'follower_id',
  dependent: :destroy
  has_many   :reverse_relationships, class_name: "Relationship",
  foreign_key: 'following_id',
  dependent: :destroy
  has_many   :followings,    :through => :relationships
  has_many   :followers,     :through => :reverse_relationships

  has_many   :grade_team_classes, foreign_key: 'teacher_id'
  belongs_to :grade_team_class

  has_many   :comments
  has_many   :albums

  has_many   :likes,         foreign_key: 'like_user_id'
  has_many   :like_records,  through: :likes, source: :likeable, source_type: 'Record'
  has_many   :like_dynamics, through: :likes, source: :likeable, source_type: 'Dynamic'

  has_many   :dynamics

  has_many   :views,        foreign_key: 'viewer_id'
  has_many   :view_records, through: :views

  belongs_to :credit
  has_many   :credit_managers

  has_many   :reports

  # has_sms_verification

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
    grade_team_class.students
  end

  # 生成4位 code
  def set_code
    loop do
    self.code = ([*?a..?z]+[*?1..?9]).sample(4).join
    break if User.where(code: code).empty?
    end
  end

  # 生成8位code
  def set_id_code
    loop do
    self.uid = ([*?a..?z]+[*?1..?9]).sample(8).join
    break if User.where(uid: uid).empty?
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
end
