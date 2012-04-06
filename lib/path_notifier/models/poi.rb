module PathNotifier
  module Models
    class POI
      include Mongoid::Document
      include Mongoid::Spacial::Document

      has_many :coordinates, class_name: "PathNotifier::Models::Coordinate"

      def self.detect_clusters
        pois = []
        Coordinate.where(:poi_scanned.ne => true).all.each do |coordinate|
          #Coordinate.geo_near([1.0, 1.0], max_distance: 1, unit: :km).should have(4).items
          nearby = Coordinate.geo_near([coordinate.location[:lng], coordinate.location[:lat]],
                                       max_distance: 1, unit: :km)
          nearby = nearby.sort_by {|i| i.id.to_s }
          
          pois << nearby unless pois.include?(nearby)
        end

        pois.each do |poi|
          self.create(:coordinates => poi)
        end
      end
    end
  end
end
