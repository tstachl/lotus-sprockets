require 'sprockets'

module Lotus
  module Sprockets
    class Middleware
      attr_reader :app, :prefix, :environment

      # @since 0.1.0
      # @api private
      def initialize(app, prefix)
        @app, @prefix = [app, prefix]
        @environment  = ::Sprockets::Environment.new
        yield(@environment) if block_given?
      end

      # @since 0.1.0
      # @api private
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
