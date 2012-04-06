module PathNotifier
  module Models
    class POI
      include Mongoid::Document
      include Mongoid::Spacial::Document

      #has_many :coordinates, class_name: "PathNotifier::Models::Coordinate"

      field :coordinate_ids, type: Array
      field :location,       type: Array, spacial: true
      spacial_index :location

      before_save :calculate_location

      def self.detect_clusters
        clusters = []
        Coordinate.desc(:timestamp).where(:poi_scanned.ne => true).all.each do |coordinate|
          print '.'
          coordinate.poi_scanned = true
          coordinate.save

          nearby = Coordinate.where(:timestamp.lte => coordinate.timestamp) \
                             .where(:timestamp.gt  => coordinate.timestamp - 30.minutes) \
                             .geo_near([coordinate.location[:lng], coordinate.location[:lat]],
                                       max_distance: 50, unit: :m, num: 10000)

          nearby = nearby.sort_by {|i| i.id.to_s }
          nearby = nearby.map(&:id).map(&:to_s)
         
          if nearby.size > 50
            clusters << nearby unless clusters.include?(nearby)
          end
        end
        puts " done"

        puts "Found #{clusters.count} clusters"
        clusters.each do |cluster|
          print '.'
          self.create(:coordinate_ids => cluster)
        end
        puts ' done'
      end

      def coordinates
        Coordinate.where(:_id.in => coordinate_ids).all
      end

      def calculate_location
        lats = coordinates.map {|coord| coord.location[:lat] }
        lngs = coordinates.map {|coord| coord.location[:lng] }
        
        lat  = lats.sum / lats.size
        lng  = lngs.sum / lngs.size

        self.location = {lat: lat, lng: lng}
      end
    end
  end
end
