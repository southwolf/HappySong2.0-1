namespace :puma do
  set_default :puma_cmd, -> { "#{cmd_prefix} puma -e #{rails_env}" }
  set_default :pumactl_cmd, -> { "#{cmd_prefix} pumactl" }

  desc "Start puma"
  task start: :environment do
    queue! %{
      cd #{deploy_to}/#{current_path} && #{puma_cmd}
    }
  end

  desc "Stop puma"
  task stop: :environment do
    pumactl_command 'stop'
    queue! %{
      rm -f #{pumactl_socket}
    }
  end

  desc "Restart puma"
  task restart: :environment do
    pumactl_command 'restart'
  end

  desc 'Restart puma (phased restart)'
  task phased_restart: :environment do
    pumactl_command 'phased-restart'
  end

  def pumactl_command(command)
    queue! %{
      cd #{deploy_to}/#{current_path} && #{pumactl_cmd} #{command}
    }
  end
end
