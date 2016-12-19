require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LoveToReadVersion2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local

    config.paths.add File.join('app', 'api'), glob: File.join('**','*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api','*')]
    config.autoload_paths += Dir["#{config.root}/app/models/org/*"]
    config.autoload_paths += Dir["#{config.root}/app/models/user"]
    config.autoload_paths += Dir["#{config.root}/app/models/work"]
    config.autoload_paths += Dir["#{config.root}/app/models/associator"]
    config.autoload_paths += Dir["#{config.root}/app/models/jpush"]

    config.autoload_paths += ["#{config.root}/lib/module"]

    config.active_job.queue_adapter = :sidekiq
  end
end
