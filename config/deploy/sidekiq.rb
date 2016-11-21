set_default :sidekiq, -> { "#{bundle_prefix} sidekiq -d" }
set_default :sidekiqctl, -> { "#{bundle_prefix} sidekiqctl" }
set_default :sidekiq_timeout, 10
set_default :sidekiq_config, -> { "#{deploy_to}/#{current_path}/config/sidekiq.yml" }
set_default :sidekiq_processes, 2
set_default :sidekiq_pid, '/shared/tmp/pids/sidekiq.pid'

namespace :sidekiq do
  def for_each_process(&block)
    sidekiq_processes.times do |idx|
      if idx == 0
        pid_file = sidekiq_pid
      else
        pid_file = "#{sidekiq_pid}-#{idx}"
      end
      yield(pid_file, idx)
    end
  end

  desc 'Quiet sidekiq (stop accepting new work)'
  task quiet: :environment do
    queue %[echo "-----> Quiet sidekiq (stop accepting new work)"]
    for_each_process do |pid_file, idx|
      queue %{
        if [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then
          cd "#{deploy_to}/#{current_path}"
          #{echo_cmd %{#{sidekiqctl} quiet #{pid_file}} }
        else
          echo 'Skip quiet command (no pid file found)'
        fi
      }
    end
  end

  desc 'Stop sidekiq'
  task stop: :environment do
    queue %{
      echo '-----> Stop sidekiq'
    }
    for_each_process do |pid_file, idx|
      queue! %{
        cd #{deploy_to}/#{current_path}
        #{sidekiqctl} stop #{pid_file} #{sidekiq_timeout}
      }
    end
  end

  desc 'Start sidekiq'
  task start: :environment do
    queue %{
      echo '-----> Start sidekiq'
    }
    for_each_process do |pid_file, idx|
      queue! %{
        cd #{deploy_to}/#{current_path}
        #{sidekiq} -d -i #{idx} -P #{pid_file}
      }
    end
  end

  desc 'run sidekiq ui'
  task :ui do
    queue! %{
      cd #{deploy_to}/#{current_path}/sidekiq
      #{thinctl} start -d -R sidekiq.ru -p 9292
    }
  end

  desc 'Restart sidekiq'
  task :restart do
    invoke :'sidekiq:stop'
    invoke :'sidekiq:start'
  end

end
