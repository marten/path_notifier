module PathNotifier
  module Models
    class Place
      include Mongoid::Document
      include Mongoid::Spacial::Document

      field :poi_ids,        type: Array
      field :location,       type: Array, spacial: true
      field :tags,           type: Array

      index :tags
      spacial_index :location

      before_save :calculate_location

      def self.detect_clusters
        clusters = []
        POI.all.each do |poi|
          print '.'

          nearby = POI.geo_near([poi.location[:lng], poi.location[:lat]],
                                max_distance: 100, unit: :m, num: 10000)

          nearby = nearby.sort_by {|i| i.id.to_s }
          nearby = nearby.map(&:id).map(&:to_s)
         
          if nearby.size > 20
            clusters << nearby unless clusters.include?(nearby)
          end
        end
        puts " done"

        puts "Found #{clusters.count} places"
        clusters.each do |cluster|
          print '.'
          self.create(:poi_ids => cluster)
        end
        puts ' done'
      end

      def pois
        POI.where(:_id.in => poi_ids).all
      end

      def calculate_location
        lats = pois.map {|poi| poi.location[:lat] }
        lngs = pois.map {|poi| poi.location[:lng] }
        
        lat  = lats.sum / lats.size
        lng  = lngs.sum / lngs.size

        self.location = {lat: lat, lng: lng}
      end
    end
  end
end

