require 'erb'
require_relative 'plain_renderer'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      return create_renderer(template).response if @env['simpler.renderer']
      
      template = File.read(template_path)

      [ERB.new(template).result(binding), 'text/html']
    end

    private

    def create_renderer(template)
      Object.const_get("#{@env['simpler.renderer']}").new(template)
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
  
end
