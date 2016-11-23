puts 'use staging'

set :domain, '121.41.104.215'
set :port, '22'
set :user, 'deploy'
set :deploy_to, '/opt/rails/happysong2'
set :rails_env, 'staging'
set :branch, 'staging'
set :keep_releases, 1
