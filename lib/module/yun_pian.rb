require 'net/http'
require 'active_support/json'
module YunPian
  extend self

  def post(api, options={})
    options[:apikey] = ENV['apikey']
    uri = URI.join(ENV['base_url'], api)
    res = Net::HTTP.post_form(uri, options)
    result res.body
  end

  def get(api, options = {})
    options[:apikey] = ENV['apikey']
    uri = URI.join(ENV['base_url'], api)
    result Net::HTTP.get(uri, options)
  end

  def deliver(mobile)
    options = {}
    api="sms/single_send.json"
    options[:mobile] = mobile.to_s
    code = set_code
    options[:text] = "【欢乐诵】您的验证码是#{code}。如非本人操作，请忽略本短信"
    result = post(api, options)
    if result['code'] == 0
      return true
    else
      return false
    end
  end


  def verify (mobile, code)
    result = get_mess(mobile)
    return false unless result
    verify_regexp = /(【.+】|[^a-zA-Z0-9\.\-\+_])/
    if result['text'].to_s.gsub(verify_regexp, '') == code.to_s
      return true
    else
      return false
    end
  end

  def get_mess(mobile)
    options = {}
    api="sms/get_record.json"
    time_now = Time.now
    end_time = time_now.strftime '%Y-%m-%d %H:%M:%S'
    start_time = (time_now - 3.minute).strftime '%Y-%m-%d %H:%M:%S'
    options[:mobile] = mobile.to_s
    options[:end_time] = end_time
    options[:start_time] = start_time
    options[:page_num] = 1
    options[:page_size] = 20

    result = post(api, options)
    if result.nil?
      result false
    else
      result.first
    end
  end


  private

  # Method that parse JSON to Hash
  #
  def set_code
    ([*?1..?9]).sample(4).join
  end

  def result(body)
    begin
      ActiveSupport::JSON.decode body
    rescue => e
      {
        code: 502,
        msg: '内容解析错误',
        detail: e.to_s
      }
    end
  end
end
