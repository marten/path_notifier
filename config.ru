ENV['RACK_ENV'] ||= 'development'
require "rubygems"
require "bundler/setup"

require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'path_notifier'))

use Rack::Static, :urls => ["/css", "/img", "/js"], :root => "public"

run PathNotifier.app

# vim:ft=ruby
