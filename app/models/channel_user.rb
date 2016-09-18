class ChannelUser < ActiveRecord::Base
  has_secure_password

  has_many :schools
  belongs_to :district

  has_many :transfers, foreign_key: "transfer_user_id"
  belongs_to :transfer, foreign_key: "collector_id"


  validates :email,:phone, uniqueness: true
  before_create :set_token

  scope :channels, ->{ where(admin: false)}

  def admin?
    self.admin == true
  end
  def company
    self.company == true
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
