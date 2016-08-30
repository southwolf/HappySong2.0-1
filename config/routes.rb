Rails.application.routes.draw do
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger_doc'

  post '/webhooks', to: 'pings#webhooks', as: :webhooks
end
