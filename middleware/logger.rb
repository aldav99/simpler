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
      
      @logger.info "#{request.session[:result]}"
      @logger.info "Response: #{status} [#{headers["Content-Type"]}]"
      
    end
  end
end



