class ChannelUser < ActiveRecord::Base
  has_secure_password

  has_many :channel_schools
  has_many :schools, :through => :channel_schools

  belongs_to :district

  has_many :transfers, foreign_key: "transfer_user_id"
  belongs_to :transfer, foreign_key: "collector_id"
  has_many :apply_cash_backs

  validates :email,:phone, uniqueness: true
  before_create :set_token

  scope :channels, ->{ where(admin: false)}

  def user_count
    schools = self.schools
    user_count = 0
    return 0 if schools.blank?
    schools.each do |school|
      user_count += school.user_count
    end
    return user_count
  end

  def vip_count
    schools = self.schools
    user_count = 0
    return 0 if schools.blank?
    schools.each do |school|
      user_count += school.vip_count
    end
    return user_count
  end
  def admin?
    self.admin == true
  end
  def company?
    self.company == true
  end
  def user_type
    if self.company?
      return "公司"
    else
      return "个人"
    end
  end

  def address
    "#{self.try(:district).try(:city).try(:name)}#{self.try(:district).try(:name)}"
  end
  private
  def set_token
    loop do
      self.token = ChannelUser.gen_token
      break if ChannelUser.where(token: token).empty?
    end
  end

  def self.gen_token
    SecureRandom.urlsafe_base64
  end
end
