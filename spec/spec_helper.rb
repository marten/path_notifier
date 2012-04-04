require "bundler/setup"
Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'lib', 'path_notifier')

Webrat.configure do |config|
  config.mode = :rack
  config.application_port = 4567
end

RSpec.configure do |config|
  config.include(Rack::Test::Methods)
  config.include(Webrat::Methods)
  config.include(Webrat::Matchers)

  config.before(:each) do
  end

  def app
    PathNotifier.app
  end
end
