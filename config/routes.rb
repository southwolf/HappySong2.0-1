Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger_doc'

  namespace :channel do
    root "channel#index"
    resources :channel_users do
      resources  :transfers, only: [:index]
    end

    resource :session, only: [:new, :create, :destroy]
  end


  get  '/webhooks', to: 'pings#test',     as: :test
  post '/webhooks', to: 'pings#webhooks', as: :webhooks
  resource :invites, only: [:show, :create]
end
