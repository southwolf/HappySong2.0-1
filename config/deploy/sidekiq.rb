set_default :sidekiq, -> { "#{bundle_prefix} sidekiq" }
set_default :sidekiqctl, -> { "#{bundle_prefix} sidekiqctl" }
set_default :sidekiq_timeout, 10
set_default :sidekiq_config, -> { "#{deploy_to}/#{current_path}/config/sidekiq.yml" }
set_default :sidekiq_processes, 2
set_default :sidekiq_pid, -> { "#{fetch(:shared_path)}/tmp/pids/sidekiq.pid" }
set_default :sidekiq_log, -> { "#{fetch(:current_path)}/log/sidekiq.log" }
set_default :sidekiq_concurrency, nil

namespace :sidekiq do
  def for_each_process(&block)
    fetch(:sidekiq_processes).times do |idx|
      pid_file = if idx == 0
                   fetch(:sidekiq_pid)
                 else
                   "#{fetch(:sidekiq_pid)}-#{idx}"
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
        command %{
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
    comment 'Stop sidekiq'
    in_path(fetch(:current_path)) do
      for_each_process do |pid_file, idx|
        command %{
          if [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then
            #{fetch(:sidekiqctl)} stop #{pid_file} #{fetch(:sidekiq_timeout)}
          else
            echo 'Skip stopping sidekiq (no pid file found)'
          fi
        }.strip
      end
    end
  end

  # ### sidekiq:start
  desc "Start sidekiq"
  task :start => :environment do
    comment 'Start sidekiq'
    in_path(fetch(:current_path)) do
      for_each_process do |pid_file, idx|
        sidekiq_concurrency = fetch(:sidekiq_concurrency)
        concurrency_arg = if sidekiq_concurrency.nil?
                            ""
                          else
                            "-c #{sidekiq_concurrency}"
                          end
        command %[#{fetch(:sidekiq)} -d -e #{fetch(:rails_env)} #{concurrency_arg} -C #{fetch(:sidekiq_config)} -i #{idx} -P #{pid_file} -L #{fetch(:sidekiq_log)}]
      end
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
    command %[tail -f #{sidekiq_log}]
  end
end
