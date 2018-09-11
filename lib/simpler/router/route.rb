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
    end
  end
end
