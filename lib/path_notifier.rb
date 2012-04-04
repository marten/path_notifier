require 'sinatra/base'

module PathNotifier
  def self.app
    @app ||= Rack::Builder.new do
      use Rack::Session::Cookie, :key => 'rack.session', :path => '/',
       :expire_after => 2592000, :secret => 'c52426df29705ac593818d5cd7005332e22d9bbf'
      run PathNotifier::App
    end
  end
end

require File.dirname(__FILE__)+'/path_notifier/app'
