require 'lotus/sprockets/version'
require 'lotus/sprockets/middleware'
require 'lotus/configuration'
require 'lotus/middleware'
require 'lotus/config/assets_paths'
require 'lotus/config/sprockets'

module Lotus
  # Configuration for the framework.
  #
  # Lotus::Sprockets has a configuration module that is included
  # in `Lotus::Configuration`
  #
  # @since 0.1.0
  class Configuration
    # Sprockets will load assets from these directories.
    #
    # By default it's equal to the `assets/` directory under the application
    # `root`.
    #
    # Otherwise, you can add differents relatives paths under `root`.
    #
    # @since 0.1.0
    #
    # @see Lotus::Configuration#serve_assets
    #
    # @example Getting the value
    #   require 'lotus'
    #
    #   module Bookshelf
    #     class Application < Lotus::Application
    #     end
    #   end
    #
    #   Bookshelf::Application.configuration.assets
    #     # => #<Lotus::Config::Sprockets:/root/path/assets>
    #
    # @example Adding new assets paths
    #   require 'lotus'
    #
    #   module Bookshelf
    #     class Application < Lotus::Application
    #       configure do
    #         serve_assets true
    #         assets.paths << 'vendor/assets'
    #       end
    #     end
    #   end
    #
    #   Bookshelf::Application.configuration.assets
    #     # => #<Lotus::Config::Sprockets:/root/path/assets, @paths=['assets', 'vendor/assets']>
    #
    def assets
      @assets ||= Lotus::Config::Sprockets.new(root)
    end
  end

  class Middleware
    # Add asset middlewares
    #
    # @api private
    # #since 0.2.0
    def _load_asset_middlewares
      assets = @configuration.assets

      if @configuration.serve_assets
        use Sprockets::Middleware, assets.prefix, &assets.build

        # still add static roots
        assets.static.entries.each do |path, children|
          use Rack::Static, urls: children, root: path
        end
      end
    end
  end

  # Sprockets
  #
  # @since 0.1.0
  module Sprockets
  end
end
