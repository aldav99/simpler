require 'yaml'
require 'singleton'
require 'sequel'
require_relative 'router'
require_relative 'controller'

module Simpler
  class Application

    include Singleton

    attr_reader :db

    def initialize
      @router = Router.new
      @db = nil
    end

    def bootstrap!
      setup_database
      require_app
      require_routes
    end

    def routes(&block)
      @router.instance_eval(&block)
    end

    def call(env)
      @request = Rack::Request.new(env)

      route = @router.route_for(env)
      return route_not_find unless route
      @controller = route.controller.new(env)
      @action = route.action

      result

      make_response(@controller, @action)
    end

    private

    def result

      header_template = [@controller.name, @action].join('/')
      handler = [@controller.class.name, @action].join('#')
      parameters = @request.params.to_s

      result = "\nHandler: #{handler}\nParameters: #{@request.params.to_s}\nTemplate: #{header_template}.html.erb"
      
      @request.session[:result] = result
    end

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].each { |file| require file }
    end

    def require_routes
      require Simpler.root.join('config/routes')
    end

    def setup_database
      database_config = YAML.load_file(Simpler.root.join('config/database.yml'))
      database_config['database'] = Simpler.root.join(database_config['database'])
      @db = Sequel.connect(database_config)
    end

    def make_response(controller, action)
      controller.make_response(action)
    end

    def route_not_find
      [404, {"Content-Type" => "text/html"}, ["I'm Lost!\n"]]
    end

  end
end
