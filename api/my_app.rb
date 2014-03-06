require "rails"
require "rails/all"

#------------------
# EXTRACT THIS INTO IT'S OWN GEM
#
#
class MiniConfig < Rails::Application::Configuration
  def paths
    @paths ||= begin
      paths = super
      paths.add "api/controllers",     eager_load: true
      paths.add "api/models",          eager_load: true
      paths.add "api/mailers",         eager_load: true
      paths.add "api/initializers",    glob: "**/*.rb"
      paths.add "api/routes.rb"
      paths
    end
  end
end

module Rails
  class Application < Engine

  class << self
    attr_reader :env_configs
  end

  def self.environment(*envs, &block)
    @env_configs ||= ActiveSupport::HashWithIndifferentAccess.new
    envs.each do |env|
      @env_configs[env] = block
    end
  end

  def config #:nodoc:
    @config ||= MiniConfig.new(find_root_with_flag("config.ru", Dir.pwd))
  end

  def env_configs
    self.class.env_configs
  end

  def routes
    @routes ||= ActionDispatch::Routing::RouteSet.new
    @routes.append(&Proc.new) if block_given?
    @routes
  end

  initializer :load_environment_config, before: :load_environment_hook do
    env_configs[Rails.env].call
  end

  initializer :load_routes do |app|
    paths = self.paths["api/routes.rb"].existent

    if routes? || paths.any?
      app.routes_reloader.paths.unshift(*paths)
      app.routes_reloader.route_sets << routes
    end
  end

end
end
#
# END EXTRACTION
#-----------------

class MyApp < Rails::Application

  config.api_only = true
  config.session_store = true
  config.secret_token = "49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk"

  environment :development, :test do
    config.serve_static_assets = true
    config.eager_load = false
    config.active_support.deprecation = :log
  end

  environment :production do
    config.eager_load = true
    config.consider_all_requests_local = false
    config.action_controller.perform_caching = true
    config.serve_static_assets = false
    config.log_formatter = ::Logger::Formatter.new
  end

end
