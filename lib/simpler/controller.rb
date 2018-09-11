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

    

    protected

    def route_params
      hash_params(@request.env['REQUEST_PATH'], @request.env['simpler.route'])["id"]
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

    def route_element?(elem)
      elem[0] == ':'
    end

    def string_to_array(string)
      string.split('/').reject {|e| e.empty?}
    end

    def path_to_hash(string)
      hash_path = {}
      arr = string_to_array(string)
      arr.each_index do |i|
        hash_path[arr[i][1..arr[i].length]] = i if route_element?(arr[i])
      end
      hash_path
    end

    def hash_params(path, route)
      params = {}
      path = string_to_array(path)
      hash_route = path_to_hash(route)
      hash_route.each { |key, value| params[key] = path[value] }
      params
    end

  end
end

