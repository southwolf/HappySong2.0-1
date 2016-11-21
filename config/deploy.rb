require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/whenever'
require_relative 'deploy/sidekiq'
require_relative 'deploy/puma'


if ENV['on'].nil?
  require File.expand_path('../deploy/staging.rb', __FILE__)
else
  require File.expand_path("../deploy/#{ENV['on']}.rb", __FILE__)
end

set :repository, 'git://...'
set :cmd_prefix, -> { "RAILS_ENV=#{rails_env}" }
set :rack_prefix, -> { %{RACK_ENV="#{rails_env}" #{bundle_bin} exec } }
set :shared_paths, [
  'config/database.yml',
  'config/secrets.yml',
  'log'
]

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/puma.rb"]

  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' 'puma.rb' and 'secrets.yml'."]

  if repository
    repo_host = repository.split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(repository) && /:([0-9]+)/.match(repository)[1] || '22'

    queue %[
      if ! ssh-keygen -H  -F #{repo_host} &>/dev/null; then
        ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
      fi
    ]
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:assets_precompile'
    invoke :'rails:db_create'
    invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'puma:restart'
      invoke :'sidekiq:restart'
      invoke :'whenever:update'
    end
  end
end

desc "Restart"
task :restart do
  queue! %{
    touch "#{deploy_to}/#{current_path}/tmp/restart.txt"
  }
end
