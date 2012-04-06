require 'bundler/setup'
Bundler.require(:default)
require_relative "../lib/path_notifier"
Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("path_notifier_dev")
end

PathNotifier::Models::POI.delete_all
PathNotifier::Models::Coordinate.update_all(:poi_scanned => false)
PathNotifier::Models::POI.detect_clusters

puts "Database now has #{PathNotifier::Models::POI.count} clusters"
