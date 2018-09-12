require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)

    request = Rack::Request.new(env)

    @logger.info "Request: #{env["REQUEST_METHOD"]} #{env["REQUEST_URI"]}"

    @app.call(env).tap do |response|
      status, headers, _ = response

      controller = request.env['simpler.controller']
      action = request.env['simpler.action']

      @logger.info "Handler: #{[controller.class.name, action].join('#')}"
      @logger.info "Parameters:: #{controller.request_params}"
      @logger.info "Template: #{[controller.name, action].join('/')}.html.erb"

      @logger.info "Response: #{status} [#{headers["Content-Type"]}]"
    end
  end
end

