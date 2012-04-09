require 'bundler/setup'
Bundler.require(:default)
require_relative "../lib/path_notifier"
Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("path_notifier_dev")
end

puts 'Getting session'
@session ||= Geoloqi::Session.new :access_token => ENV['GEOLOQI_TOKEN']

puts 'Getting layers'
layers = @session.get('layer/list')[:layers]

if layer = layers.detect {|i| i[:name] == "PathNotifier" }
  puts 'Found existing layer'
  @layer_id = layer[:layer_id]
else
  puts 'Did not find existing PathNotifier layer'
  results = @session.post('layer/create', name: "PathNotifier")
  @layer_id = results[:layer_id]
  puts '  created #{@layer_id}'
end

puts 'Getting triggers'
triggers = @session.get('trigger/list', layer_id: @layer_id)[:triggers]

puts "Ensuring places have triggers"
PathNotifier::Models::Place.all.each do |place|
  if not triggers.detect {|i| i[:key] == "T#{place.id}" }
    puts "Place #{place.id} does not have trigger, creating."
    puts @session.post('trigger/create', key: "T#{place.id}",
                                    type: "callback",
                                    url: "http://home.veldthuis.com:9393/geoloqi-callback",
                                    one_time: false,
                                    latitude: place.location[:lat],
                                    longitude: place.location[:lng],
                                    radius: 100,
                                    place_layer_id: @layer_id,
                                    place_key: place.id,
                                    place_name: place.id)
  else
    puts "Place #{place.id} already has a trigger"
  end
end
