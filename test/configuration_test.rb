require 'test_helper'

describe Lotus::Configuration do
  before do
    @configuration = Lotus::Configuration.new
  end

  describe 'assets' do
    before do
      @configuration.root 'test/fixtures/collaboration/apps/web'
    end

    it 'overrides assets method' do
      @configuration.assets.must_be_instance_of Lotus::Config::Sprockets
    end

    it 'allows to set a css compressor' do
      @configuration.assets.css_compressor(:yui)
      @configuration.assets.css_compressor.must_equal :yui
    end

    it 'allows to set a js compressor' do
      @configuration.assets.js_compressor(:yui)
      @configuration.assets.js_compressor.must_equal :yui
    end
  end
end
