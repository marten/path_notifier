ENV['RACK_ENV'] ||= 'development'
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'path_notifier'))

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("path_notifier_dev")
end

use Rack::Static, :urls => ["/css", "/img", "/js"], :root => "public"

run PathNotifier.app

# vim:ft=ruby
