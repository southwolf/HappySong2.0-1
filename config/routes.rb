Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger_doc'

  get 'xieyi/xieyi'    => 'xieyi#xieyi'
  get '/zhifu' => 'zhifu#zhifu'
  namespace :channel do
    root "channel#index"
    resources :channel_users do
      resources  :transfers, only: [:index, :new, :create]
    end

    resources :channel_users do
      resources  :apply_cash_backs
    end

    post 'channel_users/create' => 'channel_users/create'
    #报备学校
    post 'school/addSchool' => 'school/addSchool'

    #消息提醒
    get 'message/admin_index' => 'message/admin_index'

    #报备pass
    get 'message/pass_school' => 'message/pass_school'
    #报备申请 失败
    get 'message/nopass_school' => 'message/nopass_school'

    #转账pass
    get 'message/pass_tx' => 'message/pass_tx'

    #渠道商报备记录
    get 'message/channel_baobei' => 'message/channel_baobei'

    #添加新学校
    post 'school/schoolAdd' => 'school/schoolAdd'

    #申请提现
    post 'school/apply_cash_ajax' => 'school/apply_cash_ajax'

    #学校是否已报备
    post 'school/checkSchool' => 'school/checkSchool'

    #根据学校id查看用户注册信息
    post 'school/show_ajax' => 'school/show_ajax'

    #用户注册
    get 'sessions/register' => 'sessions/register', as: :register

    #登录
    post 'sessions/checklogin' => 'sessions/checklogin'

    post 'sessions/doreg' => 'sessions/doreg'

    resources :school, only: [:show,:new, :create]

    resource :session, only: [:new, :create, :destroy]
 end

  namespace :admin do
    root "admin#index"
    post 'admin/index_ajax' => 'admin/index_ajax'
    get 'admin/show' => 'admin/show'
    patch 'admin/update' => 'admin/update'
    get 'admin/changedistrict' => 'admin/changedistrict'
    get 'admin/changepwd' => 'admin/changepwd'
    get 'admin/dochangepwd' => 'admin/dochangepwd'
    get 'admin/delchannel' => 'admin/delchannel'
    post 'admin/forbidden' => 'admin/forbidden'
  end



  get  '/share_article/:id', to: 'shares#share_article', as: :share_article
  get  '/share_record/:id',  to: 'shares#share_record',  as: :share_record
  get  '/share_dynamic/:id', to: 'shares#share_dynamic', as: :share_dynamic
  get  '/share_profile/:id', to: 'shares#share_profile', as: :share_profile

  get  '/webhooks', to: 'pings#test',     as: :test
  post '/webhooks', to: 'pings#webhooks', as: :webhooks
  resource :invites, only: [:show, :create]
end
