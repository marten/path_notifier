module PathNotifier
  module Models
    class Route
      SCAN_RADIUS = 100

      include Mongoid::Document

      field :occurances, type: Integer, default: 1

      belongs_to :source,      class_name: "PathNotifier::Models::Place"
      belongs_to :destination, class_name: "PathNotifier::Models::Place"
      
      def self.detect
        @coordinates = Models::Coordinate.all
        @groups = @coordinates.group_by {|i| [i.timestamp.year, i.timestamp.month, i.timestamp.day].join('-') }

        @groups.each do |date, coordinates|
          puts "Scanning routes for #{date}"

          pairs = []
          previous_place = nil
          coordinates.each do |coord|
            #print '.'
            loc = [coord.location[:lng], coord.location[:lat]]
            places = Place.geo_near(loc, max_distance: SCAN_RADIUS, unit: :m)
            places = places.sort_by {|i| i.geo[:distance] }

            if place = places.first
              if not previous_place
                previous_place = place
              end

              if previous_place != place
                pairs << [previous_place, place]
                previous_place = place
              end
            end
          end

          pairs.each do |pair|
            route = Route.where(:source_id => pair[0].id, :destination_id => pair[1].id).first
            if route
              route.inc(:occurances, 1)
            else
              Route.safely.create(:source_id => pair[0].id, :destination_id => pair[1].id)
            end
          end

          puts ' done'
        end

        puts Route.all
      end

      def serializable_hash(options = nil)
        options ||= {}
        options[:include] = [:source, :destination]
        super(options).tap do |attrs|
          serialize_relations(attrs, options) if options[:include]
        end
      end
    end
  end
end
