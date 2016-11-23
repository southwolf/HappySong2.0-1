puts 'use production'

set :domain, '120.26.118.28'
set :port, '22'
set :user, 'deploy'
set :deploy_to, '/opt/rails/happysong2'
set :branch, 'master'
set :rails_env, 'production'
set :keep_releases, 1
