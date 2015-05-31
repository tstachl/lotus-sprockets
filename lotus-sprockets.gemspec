# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lotus/sprockets/version'

Gem::Specification.new do |spec|
  spec.name          = 'lotus-sprockets'
  spec.version       = Lotus::Sprockets::VERSION
  spec.authors       = ['Thomas Stachl']
  spec.email         = ['thomas@stachl.me']
  spec.summary       = %q{An assets pipeline for Lotus}
  spec.description   = %q{Allows for easy integration between sprockets and lotus.}
  spec.homepage      = 'https://github.com/tstachl/lotus-sprockets'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z -- lib/* CHANGELOG.md EXAMPLE.md LICENSE.md README.md lotus-model.gemspec`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency 'lotusrb',      '~> 0.3'
  spec.add_runtime_dependency 'sprockets',    '~> 3.1'

  spec.add_development_dependency 'bundler',  '~> 1.6'
  spec.add_development_dependency 'minitest', '~> 5'
  spec.add_development_dependency 'rake',     '~> 10'
end
