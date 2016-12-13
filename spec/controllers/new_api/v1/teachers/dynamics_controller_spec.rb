require 'rails_helper'

RSpec.describe NewApi::V1::Teachers::DynamicsController, type: :request do

  before do
    Teacher.create(phone: '17711111111', name: 'test_teacher')
  end

  describe "POST #create" do
    it "should response with status 201 when created" do
      post "/new_api/teachers/#{Teacher.first.id}/dynamics",
      params: post_params
      parsed_response = JSON.parse(response.body)
      expect(response.status).to be(201)
    end
  end

  private
  def post_params
    {
      dynamic: {
        start_time: Time.now,
        end_time: Time.now + 1.days,
        content: 'Test Create RecordWork',
        files: [
          {url: 'xxx1', type: 'Image' },
          {url: 'xxx2', type: 'Image' }
        ],
        class_ids: [
          1, 24
        ]
      }
    }.merge({
      token: Teacher.first.auth_token
    })
  end
end
