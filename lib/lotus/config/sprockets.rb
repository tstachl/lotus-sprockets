module Lotus
  module Config
    class Sprockets
      attr_reader :root

      # @since 0.1.0
      # @api private
      def initialize(root)
        @root = root
      end

      # @since 0.1.0
      def build
        @proc ||= proc do |env|
          paths.entries.each do |path, children|
            children.each { |child| env.append_path path + child }
          end

          env.js_compressor = js_compressor
          env.css_compressor = css_compressor
        end
      end

      # Assets Prefix
      #
      # @overload prefix(value)
      #   Sets the given value
      #   @param value [String] prefix for the assets
      #
      # @overload prefix
      #   Gets the value
      #   @return [String] prefix for the assets
      def prefix(value = nil)
        if value
          @prefix = value
        else
          @prefix || '/assets'
        end
      end

      # Assets Digest
      #
      # @overload digest(value)
      #   Sets the given value
      #   @param value [String] digest for the assets
      #
      # @overload digest
      #   Gets the value
      #   @return [String] digest for the assets
      def digest(value = nil)
        if value
          @digest = value
        else
          @digest
        end
      end

      # CSS compressor value
      #
      # @overload css_compressor(value)
      #   Sets the given value
      #   @param value [Symbol] for the CSS compressor to use
      #
      # @overload css_compressor
      #   Gets the value
      #   @return [Symbol] CSS compressor value
      def css_compressor(value = nil)
        if value
          @css_compressor = value
        else
          @css_compressor
        end
      end

      # JavaScript compressor value
      #
      # @overload js_compressor(value)
      #   Sets the given value
      #   @param value [Symbol] for the JavaScript compressor to use
      #
      # @overload js_compressor
      #   Gets the value
      #   @return [Symbol] JavaScript compressor value
      def js_compressor(value = nil)
        if value
          @js_compressor = value
        else
          @js_compressor
        end
      end

      # Sprockets will load assets from these directories.
      #
      # By default it's equal to the `assets/` directory under the application
      # `root`.
      #
      # Otherwise, you can add differents relatives paths under `root`.
      #
      # @overload paths
      #   Gets the value
      #   @return [Lotus::Config::AssetsPaths] assets root
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
      #   Bookshelf::Application.configuration.assets.paths
      #     # => #<Lotus::Config::AssetsPaths:/root/path/assets>
      #
      # @example Adding new assets paths
      #   require 'lotus'
      #
      #   module Bookshelf
      #     class Application < Lotus::Application
      #       configure do
      #         serve_assets true
      #         assets.paths << [
      #           'vendor/assets'
      #         ]
      #       end
      #     end
      #   end
      #
      #   Bookshelf::Application.configuration.assets.paths
      #     # => #<Lotus::Config::AssetsPaths:/root/path/assets @paths=["assets", "vendor/assets"]>
      #
      def paths
        @paths ||= Config::AssetsPaths.new(@root)
      end

      # The application will serve the static assets under these directories.
      #
      # By default it's equal to the `public/` directory under the application
      # `root`.
      #
      # Otherwise, you can add differents relatives paths under `root`.
      #
      # @overload assets
      #   Gets the value
      #   @return [Lotus::Config::Assets] assets root
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
      #   Bookshelf::Application.configuration.assets.static
      #     # => #<Pathname:/root/path/public>
      #
      # @example Adding new assets paths
      #   require 'lotus'
      #
      #   module Bookshelf
      #     class Application < Lotus::Application
      #       configure do
      #         serve_assets true
      #         assets.static << [
      #           'vendor/assets'
      #         ]
      #       end
      #     end
      #   end
      #
      #   Bookshelf::Application.configuration.assets.static
      #     # => #<Lotus::Config::Assets @root=#<Pathname:/root/path/assets>, @paths=["public", "vendor/assets"]>
      #
      def static
        @static ||= Config::Assets.new(@root)
      end
    end
  end
end
