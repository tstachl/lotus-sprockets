require 'test_helper'

describe Lotus::Middleware do
  before do
    Dir.chdir($pwd)
    config = config_blk
    MockApp = Module.new
    MockApp::Application = Class.new(Lotus::Application) do
      configure(&config)
    end
  end

  after do
    Object.send(:remove_const, :MockApp)
  end

  let(:application)   { MockApp::Application.new }
  let(:configuration) { application.configuration }
  let(:middleware)    { configuration.middleware }
  let(:config_blk) do
    proc do
      root 'test/fixtures/collaboration/apps/web'
      serve_assets true
    end
  end

  it 'contains Rack::MethodOverride by default' do
    middleware.stack.must_include [Rack::MethodOverride, [], nil]
  end

  describe "when it's configured with assets" do
    let(:urls) { configuration.assets.static.entries.values.flatten }

    it 'contains Rack::Static by default' do
      middleware.stack.must_include [Rack::Static, [{ urls: urls, root: configuration.root.join('public').to_s }], nil]
    end

    it 'contains assets routes' do
      middleware.stack.must_include [
        Lotus::Sprockets::Middleware, ['/assets'], configuration.assets.build
      ]
    end
  end

  describe "when it's configured with disabled assets" do
    let(:config_blk) { proc { serve_assets false } }

    it 'does not include Rack::Static' do
      middleware.stack.flatten.wont_include(Rack::Static)
    end
  end
end
