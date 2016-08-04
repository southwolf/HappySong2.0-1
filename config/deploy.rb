# config valid only for current version of Capistrano
lock '3.6.0'

set :application, 'love_to_read_version2'
set :user, 'deploy'

set :ssh_options, {
  forward_agent: true,
  keys: %w(~/.ssh/aliyun_dora),
  port: 2200
}

set :use_sudo, false
set :scm, :git
set :repo_url, 'git@git.coding.net:silent_hill/love_to_read_version2.git'
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :deploy_to, '/apps/love_to_read_version2'

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle }

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :keep_releases, 5
set :bundle_binstubs, nil

set :rbenv_ruby, '2.3.0'

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
namespace :deploy do
  desc "Start Application"
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, "exec thin start -C #{shared_path}/config/thin.yml"
      end
    end
  end

  desc "restart Application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, "exec thin restart -C #{shared_path}/config/thin.yml"
      end
    end
  end

  desc "stop Application"
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, "exec thin stop -C #{shared_path}/config/thin.yml"
      end
    end
  end

  after "deploy", "deploy:migrate"
  after "deploy", "deploy:restart"
  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:compile_assets'
end
