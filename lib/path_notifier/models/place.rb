module PathNotifier
  module Models
    class Place
      SCAN_RADIUS = 25

      include Mongoid::Document
      include Mongoid::Spacial::Document

      field :poi_ids,        type: Array
      field :location,       type: Array, spacial: true
      field :tags,           type: Array
      field :tasks,          type: Array, default: []
      field :active,         type: Boolean, default: true

      default_scope where(:active.ne => false)

      index :tags
      spacial_index :location

      before_save :calculate_location

      def self.find_near(location)
        Place.geo_near([location[:lng], location[:lat]],
                       max_distance: SCAN_RADIUS, unit: :m).sort_by {|i| i.geo[:distance] }
      end

      def self.detect_clusters
        clusters = []
        POI.where(:place_scanned.ne => true).all.each do |poi|
          poi.place_scanned = true
          poi.save

          near_places = Place.find_near(poi.location)
          if near_places.any?
            place = near_places.first
            place.poi_ids << poi.id
            place.save

            print 'A'
          else
            nearby = POI.geo_near([poi.location[:lng], poi.location[:lat]],
                                  max_distance: SCAN_RADIUS, unit: :m, num: 10000)

            nearby = nearby.sort_by {|i| i.id.to_s }
            nearby = nearby.map(&:id).map(&:to_s)
           
            if nearby.size > 20
              self.safely.create(:poi_ids => nearby)
              print 'C'
            else
              print '.'
            end
          end
        end
        puts " done"

        # Ensure no places near to eachother
        puts 'Detecting and removing duplicate places'
        while duplicate_place = find_duplicate_place
          puts "Destroying #{duplicate_place.id}"
          duplicate_place.active = false
          duplicate_place.save
        end

        puts ' done'
      end

      def self.find_duplicate_place
        Place.all.each do |place|
          near_places = Place.where(:_id.ne => place.id) \
                             .geo_near([place.location[:lng], place.location[:lat]],
                                       max_distance: SCAN_RADIUS, unit: :m)
          return near_places.first if near_places.any?
        end

        false
      end


      def pois
        POI.where(:_id.in => poi_ids).all
      end

      def has_tasks?
        tasks.any?
      end
      
      def title
        if has_tasks?
          "#{self.id}: #{tasks.join('; ')}"
        else
          self.id.to_s
        end
      end

      def serializable_hash(options = nil)
        super(options).tap do |attrs|
          attrs.delete("poi_ids")
          attrs["title"] = self.title
        end
      end

      protected

      def calculate_location
        self.poi_ids = poi_ids.uniq
        
        unless pois.empty?
          lats = pois.map {|poi| poi.location[:lat] }
          lngs = pois.map {|poi| poi.location[:lng] }
          
          lat  = lats.sum / lats.size
          lng  = lngs.sum / lngs.size

          self.location = {lat: lat, lng: lng}
        end
      end
    end
  end
end

