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

  has_many   :team_class_users
  has_many   :team_classes,  :through => :team_class_users

  has_many   :grade_team_classes
  has_sms_verification

  def add_role name
    role = Role.find_by_name(name)
    if role.nil?
      self.create_role(:name => name)
    else
      self.role = role
      self.save
    end
  end

  def has_role? name
    role.try(:name) == name
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

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

  # 我的同学
  def classmates
    team_class_id = self.team_classes.first.try(:id)
    classmate_ids = TeamClassUser.where(team_class_id: team_class_id)
    User.where(id: classmate_ids)
  end

  def set_code
    loop do
      self.code = ([*?a..?z]+[*?1..?9]).sample(4).join
      break if User.where(code: code).empty?
    end
  end

  def set_id_code
    loop do
      self.uid = ([*?a..?z]+[*?1..?9]).sample(8).join
      break if User.where(uid: uid).empty?
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
