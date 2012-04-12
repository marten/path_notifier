require 'bundler/setup'
Bundler.require(:default)
require_relative "../lib/path_notifier"
Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("path_notifier_dev")
end

PathNotifier::Models::Coordinate.delete_all
PathNotifier::GeoloqiImporter.update(Time.gm(2012,01,01,01,00,00))
puts "Database now has #{PathNotifier::Models::Coordinate.count} coords"
