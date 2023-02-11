require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AppraisalPortal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.session_store :cookie_store, key: '_employee_portal_session'
    config.api_only = true
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::Cors
    config.middleware.use Rack::MethodOverride
    config.middleware.use config.session_store 
    config.session_options
    config.load_defaults 7.0
    config.autoload_paths << "lib"
    # config.active_record.belongs_to_required_by_default = false
    config.time_zone = 'Asia/Kolkata'
    config.active_record.default_timezone = :local
  end
end
