puts 'use staging'

set :domain, '121.41.104.215'
set :port, '22'
set :user, 'deploy'
set :deploy_to, '/data/www/ichem'
set :rails_env, 'staging'
set :keep_releases, 1
