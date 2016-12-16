# order 需要一个状态 state
class Order < ApplicationRecord
  self.table_name = 'bills'

  # associations
  belongs_to :actor, class_name: 'User', foreign_key: :user_id
  belongs_to :targeter, class_name: 'User', foreign_key: :target_user_id

  # callbacks
  before_create :ensure_order_no
  def ensure_order_no
    self.order_no = generate_order_no if order_no.blank?
  end

  # after_commit :connect_pingpp, on: :create
  def connect_pingpp
    begin
      charge = Pingpp::Charge.create(build_pingpp_params)
      update_columns(charge_id: charge["id"] )
      return charge
    rescue
      {
        charge: {
          message: 'TODO'
        }
      }
    end
  end


  private
  def build_pingpp_params
    {
      subject: '[欢乐诵] 充值',
      body: '[欢乐诵] 会员充值',
      amount: self.amount,
      order_no: self.order_no,
      channel: self.channel,
      currency: 'cny',
      client_ip: self.client_ip,
      app: {
        id: 'app_yT48q5PWfLyL8qvj'
      }
    }
  end

  def generate_order_no
    loop do
      no = "AO" << Time.now.strftime("%Y%m%d") << generate_number(5)
      break no unless Order.where(order_no: no).first
    end
  end

  def generate_number(len)
    (('A'..'Z').to_a + (0..9).to_a).shuffle.last(len).join
  end
end
