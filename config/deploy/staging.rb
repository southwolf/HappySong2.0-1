puts 'use staging'

set :domain, '121.41.104.215'
set :port, '22'
set :user, 'deploy'
set :deploy_to, '/rails/happysong2/'
set :rails_env, 'rails-5'
set :keep_releases, 1
