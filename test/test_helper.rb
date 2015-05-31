require 'rubygems'
require 'bundler/setup'

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    command_name 'test'
    add_filter   'test'
  end
end

FIXTURES_ROOT = Pathname(File.dirname(__FILE__) + '/fixtures').realpath

require 'minitest/autorun'
$:.unshift 'lib'
require 'lotus'
require 'lotus-sprockets'

Minitest.after_run do
  lotusrc = Pathname.new(__dir__ + '/../.lotusrc')
  lotusrc.delete if lotusrc.exist?
end

Lotus::Application.class_eval do
  def self.clear_registered_applications!
    synchronize do
      applications.clear
    end
  end
end

Lotus::Config::LoadPaths.class_eval do
  def clear
    @paths.clear
  end

  def include?(object)
    @paths.include?(object)
  end

  def empty?
    @paths.empty?
  end
end

Lotus::Middleware.class_eval { attr_reader :stack }

class DependenciesReporter
  LOTUS_GEMS = [
    'lotus-utils',
    'lotus-validations',
    'lotus-router',
    'lotus-model',
    'lotus-view',
    'lotus-controller'
  ].freeze

  def initialize
    @dependencies = dependencies
  end

  def run
    return unless ENV['TRAVIS']

    dependencies.each do |dep|
      source = dep.source
      puts "#{ dep.name } - #{ source.revision }"
    end
  end

  private
  def dependencies
    Bundler.environment.dependencies.find_all do |dep|
      LOTUS_GEMS.include?(dep.name)
    end
  end
end

DependenciesReporter.new.run

$pwd = Dir.pwd

# db = Pathname.new(__dir__).join('../tmp/assets')
# db.dirname.mkpath        # create directory if not exist
#
# sql = db.join('sql.db')
# sql.delete if sql.exist? # delete file if exist
#
# filesystem = db.join('filesystem')
# filesystem.rmtree if filesystem.exist?
# filesystem.dirname.mkpath # recreate directory
#
# if Lotus::Utils.jruby?
#   require 'jdbc/sqlite3'
#   Jdbc::SQLite3.load_driver
#   SQLITE_CONNECTION_STRING = "jdbc:sqlite:#{ sql }"
# else
#   require 'sqlite3'
#   SQLITE_CONNECTION_STRING = "sqlite://#{ sql }"
# end
#
# FILE_SYSTEM_CONNECTION_STRING = "file:///#{ filesystem }"
# require 'fixtures'
