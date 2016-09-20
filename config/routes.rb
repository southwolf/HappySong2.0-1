Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger_doc'

  namespace :channel do
    root "channel#index"
    resources :channel_users do
      resources  :transfers, only: [:index, :new, :create]
    end

    resources :school, only: [:show,:new, :create]

    resource :session, only: [:new, :create, :destroy]
  end

  namespace :admin do
    root "admin#index"
  end


  get  '/share_article/:id', to: 'shares#share_article', as: :share_article
  get  '/share_record/:id',  to: 'shares#share_record',  as: :share_record
  get  '/share_dynamic/:id', to: 'shares#share_dynamic', as: :share_dynamic
  get  '/share_profile/:id', to: 'shares#share_profile', as: :share_profile
    
  get  '/webhooks', to: 'pings#test',     as: :test
  post '/webhooks', to: 'pings#webhooks', as: :webhooks
  resource :invites, only: [:show, :create]
end
