Rails.application.routes.draw do
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger_doc'

  get  '/webhooks', to: 'pings#test',     as: :test
  post '/webhooks', to: 'pings#webhooks', as: :webhooks
  resource :invites, only: [:show, :create]
end
