set_default :sidekiq, -> { "#{bundle_prefix} sidekiq" }
set_default :sidekiqctl, -> { "#{bundle_prefix} sidekiqctl" }
set_default :sidekiq_timeout, 10
set_default :sidekiq_processes, 2
set_default :sidekiq_pid, -> { "#{deploy_to}/#{shared_path}/tmp/pids/sidekiq.pid" }
set_default :sidekiq_log, -> { "log/sidekiq.log" }
set_default :sidekiq_config, -> { "#{deploy_to}/#{current_path}/config/sidekiq.yml" }
set_default :sidekiq_concurrency, nil

namespace :sidekiq do
  def for_each_process(&block)
    sidekiq_processes.times do |idx|
      pid_file = if idx == 0
        sidekiq_pid
      else
        "#{sidekiq_pid}-#{idx}"
      end
      yield(pid_file, idx)
    end
  end

  # ### sidekiq:quiet
  desc "Quiet sidekiq (stop accepting new work)"
  task :quiet => :environment do
    comment 'Quiet sidekiq (stop accepting new work)'
    in_path(fetch(:current_path)) do
      for_each_process do |pid_file, idx|
        queue %{
          if [ -f #{pid_file} ] && kill -0 `cat #{pid_file}` > /dev/null 2>&1; then
            #{fetch(:sidekiqctl)} quiet #{pid_file}
          else
            echo 'Skip quiet command (no pid file found)'
          fi
        }.strip
      end
    end
  end

  # ### sidekiq:stop
  desc "Stop sidekiq"
  task :stop => :environment do
    queue %{
      echo '-------> Stop sidekiq'
    }

    for_each_process do |pid_file, idx|
      queue %{
        cd #{deploy_to}/#{current_path}
        if [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then
          #{sidekiqctl} stop #{pid_file} #{sidekiq_timeout}
        else
          echo '--> Skip stopping sidekiq (no pid file found)'
        fi
      }
    end
  end

  # ### sidekiq:start
  desc "Start sidekiq"
  task :start => :environment do
    queue %{
      echo '-------> Start sidekiq'
    }
    for_each_process do |pid_file, idx|
      queue! %{
        cd #{deploy_to}/#{current_path}
        #{sidekiq} -d -e #{rails_env} -C #{sidekiq_config} -i #{idx} -P #{pid_file} -L #{sidekiq_log}
      }
    end
  end

  # ### sidekiq:restart
  desc "Restart sidekiq"
  task :restart do
    invoke :'sidekiq:stop'
    invoke :'sidekiq:start'
  end

  desc "Tail log from server"
  task :log => :environment do
    queue! %{
      tail -n 500 #{deploy_to}/#{current_path}/#{sidekiq_log}
    }
  end
end
