require_relative 'view'

module Simpler
  class Controller


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

    

    def route_params
      params = {}

      route_element_position = @request.env['simpler.route'].route_element_position
      route_segment_arr = string_to_array(@request.env['simpler.route'].path)
      path_segment_arr = string_to_array(@request.env['REQUEST_PATH'])

      route_element_position.each { |pos| params[route_segment_arr[pos][1..route_segment_arr[pos].length]] = path_segment_arr[pos] }

      # route_segment_arr.each_index do |i|
      #   if route_element?(route_segment_arr[i])
      #     params[route_segment_arr[i][1..route_segment_arr[i].length]] = path_segment_arr[i]
      #   else
      #     return params if route_segment_arr[i] != path_segment_arr[i]
      #   end
      # end

      params
    end

    def request_params
      @request.params
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
      @response['Content-Type'] = render_body[1] 
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    # def params
    #   @request.params
    # end

    def render(template, options = {format: :html, status: 200})
      @response.status = status(options)

      @request.env['simpler.format'] = options[:format]

      @request.env['simpler.template'] = template
    end

    def status(options)
      options[:status]
    end

    # def route_element?(elem)
    #   elem[0] == ':'
    # end

    def string_to_array(string)
      string.split('/').reject {|e| e.empty?}
    end

    
  end
end

