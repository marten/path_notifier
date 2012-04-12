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

puts 'Getting places'
places = @session.get('place/list', layer_id: @layer_id, include_unnamed: true)[:places] 

def delete_trigger(trigger)
  @session.post("trigger/delete/#{trigger[:trigger_id]}")
end

def create_trigger(place, radius)
  @session.post('trigger/create', key: "T#{place.id}-#{radius}",
                                  type: "callback",
                                  url: "http://work.veldthuis.com:9393/geoloqi-callback",
                                  one_time: false,
                                  latitude: place.location[:lat],
                                  longitude: place.location[:lng],
                                  radius: radius,
                                  place_layer_id: @layer_id,
                                  place_key: place.id,
                                  place_name: place.id)
end

puts "Ensuring places have triggers"
PathNotifier::Models::Place.all.each do |place|
  triggers = nil
  geo_place = places.detect {|i| i[:key] == place.id.to_s }
  if geo_place
    triggers = @session.get('trigger/list', place_id: geo_place[:place_id])
    if triggers
      triggers = triggers[:triggers]
    else
      triggers = []
    end
    triggers = triggers.select {|i| i[:key] =~ /^T#{place.id}/ }
  else
    triggers = []
  end

  if triggers.blank?
    puts "Place #{place.id} does not have trigger, creating."
    puts create_trigger(place, 100)
    puts create_trigger(place, 500)
  else
    puts "Place #{place.id} already has a trigger(s), deleting and recreating"
    triggers.each {|trigger| puts delete_trigger(trigger) }
    puts create_trigger(place, 100)
    puts create_trigger(place, 500)
  end
end
