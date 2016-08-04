require 'grape-swagger'
require 'v1/base'
class API < Grape::API
  format :json
  prefix 'api'
  content_type :json, 'application/json'
  mount V1::Base
end
