require 'sprockets'

module Lotus
  module Sprockets
    class Middleware
      attr_reader :app, :prefix, :environment

      def initialize(app, prefix)
        @app, @prefix = [app, prefix]
        @environment  = ::Sprockets::Environment.new
        yield(@environment) if block_given?
      end

      def call(env)
        path_info = env['PATH_INFO']

        if path_info.start_with?(prefix)
          env['PATH_INFO'] = path_info.gsub(prefix, '')
          environment.call(env)
        else
          app.call(env)
        end
      ensure
        env['PATH_INFO'] = path_info
      end
    end
  end
end
