module Lotus
  module Config
    # Assets configuration
    #
    # @since 0.1.0
    # @api private
    class AssetsPaths < Assets
      DEFAULT_DIRECTORY = 'assets'.freeze

      # @since 0.1.0
      # @api private
      def initialize(root)
        @root = root
        @paths = Array(DEFAULT_DIRECTORY)
      end
    end
  end
end
