require 'rails_helper'

RSpec.describe NewApi::V1::Teachers::RecordsController, type: :request do

  before do
    Teacher.create(phone: '17711111111', name: 'test_teacher')
  end

  describe "POST #create" do
    it "should response with code 1001 when without authtoken" do
      post "/new_api/teachers/#{Teacher.first.id}/records",
      params: post_params
      parsed_response = JSON.parse(response.body)
      expect(response.status).to be(401)
      expect(parsed_response['error_code']).to be(1001)
    end

    it "should response with code 2002 when without article_ids or class_ids" do
      post "/new_api/teachers/#{Teacher.first.id}/records",
      params: null_ids_params
      parsed_response = JSON.parse(response.body)
      expect(response.status).to be(400)
      expect(parsed_response['error_code']).to be(2002)
    end

    it "should response with status 201 when create success" do
      post "/new_api/teachers/#{Teacher.first.id}/records",
      params: post_params_with_token
      parsed_response = JSON.parse(response.body)
      expect(response.status).to be(201)
    end
  end

  private

  def null_ids_params
    {
      record: {
        start_time: Time.now,
        end_time: Time.now + 1.days,
        content: 'Test Create RecordWork',
        article_ids: [
        ],
        class_ids: [
        ]
      }
    }.merge({
      token: Teacher.first.auth_token
    })
  end

  def post_params_with_token
    post_params.merge({
      token: Teacher.first.auth_token
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
