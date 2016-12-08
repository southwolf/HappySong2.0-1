require 'rails_helper'

RSpec.describe NewApi::V1::Teachers::RecordsController, type: :request do
  describe "POST #create" do
    it "should response with code 1001 when without authtoken" do
      post '/new_api/teachers/:teacher_id/records',
      params: post_params
      parsed_response = JSON.parse(response.body)
      expect(response.status).to be(401)
      expect(parsed_response['error_code']).to be(1001)
    end

    it "should response with code 1001 when without authtoken" do
      post '/new_api/teachers/:teacher_id/records',
      params: post_params_with_token
      binding.pry
      parsed_response = JSON.parse(response.body)
      expect(response.status).to be(401)
      expect(parsed_response['error_code']).to be(1001)
    end
  end

  private
  def post_params_with_token
    post_params.merge({
      token: '82a3b98f5a150793bcef0590e4e0d2666aeb7613'
    })
  end

  def post_params
    {
      record: {
        start_time: Time.now,
        end_time: Time.now + 1.days,
        content: 'Test Create RecordWork',
        article_ids: [
          2, 3
        ],
        class_ids: [
          1, 24
        ]
      }
    }
  end
end
