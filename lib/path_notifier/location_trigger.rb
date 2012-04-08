module PathNotifier
  class LocationTrigger
    def self.trigger(lat, lng)
      # First, update coordinates
      PathNotifier::GeoloqiImporter.update(Models::Coordinate.latest.timestamp)

      current_coord = Models::Coordinate.latest

      # Next, find place associated with trigger location
      current_place = Models::Place.geo_near([current_coord.location[:lng], current_coord.location[:lat]],
                                             max_distance: 100, unit: :m).first

      # Then see if we have tasks associated with that place
      if current_place.has_tasks?
        # If we have stuff to do at that place, see if we'd normally do it
        last_place = last_place_left_since(current_coord)
        route = Models::Route.where(:start => last_place, :destination => current_place).first

        # We have stuff to do, and we have stopped here in the past to do stuff, so
        # notify the user that he should do stuff
        if route
          Notification.new("You have stuff to do here").send
        end
      end
    end

    def self.last_place_left_since(coord)
      current_place = Models::Place.geo_near([coord.location[:lng], coord.location[:lat]],
                                             max_distance: 50, unit: :m).first

      Models::Coordinate.desc(:timestamp).where(:timestamp.lt => coord.timestamp).all.each do |other|
        # Find out if there is a place near `other`
        place = Models::Place.geo_near([other.location[:lng], other.location[:lat]],
                                       max_distance: 50, unit: :m).first

        # If the place near `other` is not where we're currently, return it
        if place and place != current_place
          return place
        end
      end

      # If we find nothing, return nil (instead of all coordinates)
      nil
    end
  end
end
