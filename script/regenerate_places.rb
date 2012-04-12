require 'bundler/setup'
Bundler.require(:default)
require_relative "../lib/path_notifier"
Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("path_notifier_dev")
end

puts "Getting new coordinates from Geoloqi"
latest = PathNotifier::Models::Coordinate.latest
time   = (latest && latest.timestamp) || Time.gm(2012,01,01,01,00,00)
PathNotifier::GeoloqiImporter.update(time)
puts "Database now has #{PathNotifier::Models::Coordinate.count} coords"

puts "Detecting new stay points"
PathNotifier::Models::POI.detect_clusters
puts "Database now has #{PathNotifier::Models::POI.count} stay points"

puts "Detecting new places"
PathNotifier::Models::Place.detect_clusters
puts "Database now has #{PathNotifier::Models::Place.count} places"
