module PathNotifier
  module Models
    class POI
      def self.detect_clusters
        pois = []
        Coordinate.all.each do |coordinate|
          #Coordinate.geo_near([1.0, 1.0], max_distance: 1, unit: :km).should have(4).items
          nearby = Coordinate.geo_near([coordinate.location[:lng], coordinate.location[:lat]],
                                       max_distance: 1, unit: :km)
          nearby = nearby.sort_by {|i| i.id.to_s }
          
          pois << nearby unless pois.include?(nearby)
        end

        pois
      end
    end
  end
end
