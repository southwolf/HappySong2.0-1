class Sms::Code < ApplicationRecord

  belongs_to :user

  before_save :regenerate_attr
  def regenerate_attr
    self.code = generate_code
    self.invalid_time = Time.now + 1.hours
  end

  # methods
  def time_valid?
    Time.now < self.invalid_time
  end

  private
  def generate_code
    ([*?1..?9]).sample(6).join
  end
end
