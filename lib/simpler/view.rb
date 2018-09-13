# require 'erb'
require_relative 'plain_renderer'
require_relative 'html_renderer'

module Simpler
  class View

    DEFAULT_RENDERER = "HtmlRenderer"

    def initialize(env)
      @env = env
    end

    def render(binding)
      create_renderer(@env).render(binding)
    end

    private

    def create_renderer(env)
      class_name = env['simpler.format'].nil? ? DEFAULT_RENDERER : "#{env['simpler.format'].capitalize}Renderer"
      Object.const_get(class_name).new(env)
    end
  end
end
