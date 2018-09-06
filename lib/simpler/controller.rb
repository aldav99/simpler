require_relative 'view'

module Simpler
  class Controller

    ENABLE_FORMATS = [:plain]

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    

    protected

    def params
      @request.env['REQUEST_PATH'].match("#{extract_name}/(?<param>\\w+)")[:param]
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] ||= 'text/html'
    end

    def write_response
      body = render_body[0]
      @response['Content-Type'] = render_body[1] || 'text/html'
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    # def params
    #   @request.params
    # end

    def render(template)
      @response.status = status(template)

      format_render(template)

      @request.env['simpler.template'] = template
    end

    def format_render(template)
      return unless template.class == Hash

      ENABLE_FORMATS.each do |format|

        @request.env['simpler.renderer'] = "#{format.capitalize}Renderer" if template.member? format
      end

    end

    def status(template)
      template.class == Hash && (template.member? :status) ? template[:status] : 200
    end

  end
end

