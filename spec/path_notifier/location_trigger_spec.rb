require 'spec_helper'

module PathNotifier
  describe LocationTrigger do
    describe '.last_place_left_since' do
      it 'returns the last place on your route' do
        coord1 = Models::Coordinate.safely.create(uuid: "1", location: {lat: 1.0, lng: 1.0}, h_accuracy: 1, timestamp: 5.minutes.ago)
        coord2 = Models::Coordinate.safely.create(uuid: "2", location: {lat: 1.0, lng: 2.0}, h_accuracy: 1, timestamp: Time.now)
        place = Models::Place.safely.create(poi_ids: [], location: {lat: 1.0, lng: 1.0})
        LocationTrigger.last_place_left_since(coord2).should == place
      end

      it "does not return a place where you're currently" do
        coord1 = Models::Coordinate.safely.create(uuid: "1", location: {lat: 1.0, lng: 1.0}, h_accuracy: 1, timestamp: 5.minutes.ago)
        coord2 = Models::Coordinate.safely.create(uuid: "2", location: {lat: 1.0, lng: 2.0}, h_accuracy: 1, timestamp: 3.minutes.ago)
        coord3 = Models::Coordinate.safely.create(uuid: "3", location: {lat: 1.0, lng: 2.0}, h_accuracy: 1, timestamp: Time.now)
        place1 = Models::Place.safely.create(poi_ids: [], location: {lat: 1.0, lng: 1.0})
        place2 = Models::Place.safely.create(poi_ids: [], location: {lat: 1.0, lng: 2.0})
        LocationTrigger.last_place_left_since(coord3).should == place1
      end
    end
  end
end
