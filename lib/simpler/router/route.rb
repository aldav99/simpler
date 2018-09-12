module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :path, :method, :regexp_path

      def initialize(method, path, controller, action, regexp_path)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @regexp_path = regexp_path
      end

      def match?(method, path)
        @method == method && path.match(@regexp_path)
      end

      def route_element_position
        route_element_position = []

        path_to_arr = @path.split('/').reject {|e| e.empty?}
        path_to_arr.each_index { |i| route_element_position << i if path_to_arr[i][0] == ':' }
        
        route_element_position
      end
    end
  end
end
