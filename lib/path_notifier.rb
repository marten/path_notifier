require 'sinatra/base'
require 'mongoid'

module PathNotifier
  def self.app
    @app ||= Rack::Builder.new do
      use Rack::Session::Cookie, :key => 'rack.session', :path => '/',
       :expire_after => 2592000, :secret => 'c52426df29705ac593818d5cd7005332e22d9bbf'
      run PathNotifier::App
    end
  end
end

require_relative 'path_notifier/app'
require_relative 'path_notifier/geoloqi_importer'
require_relative 'path_notifier/models/coordinate'
require_relative 'path_notifier/models/poi'
require_relative 'path_notifier/models/place'
