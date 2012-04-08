require "bundler/setup"
Bundler.require(:default, :test)

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("path_notifier_test")
  config.allow_dynamic_fields = false
  config.autocreate_indexes = true
  config.persist_in_safe_mode = true
end

require File.join(File.dirname(__FILE__), '..', 'lib', 'path_notifier')

Webrat.configure do |config|
  config.mode = :rack
  config.application_port = 4567
end

RSpec.configure do |config|
  config.include(Rack::Test::Methods)
  config.include(Webrat::Methods)
  config.include(Webrat::Matchers)

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  def app
    PathNotifier.app
  end
end
