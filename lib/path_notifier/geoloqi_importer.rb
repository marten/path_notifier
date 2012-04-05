module PathNotifier
  class GeoloqiImporter
    def self.session
      @session ||= Geoloqi::Session.new :access_token => ENV['GEOLOQI_TOKEN']
    end

    def self.update(since)
      result = session.get('location/history', :count => 10000, 
                                               :after => since.to_i,
                                               :ignore_gaps => 1)
      points = result[:points]

      points.each do |point|
        position = point[:location][:position]
        Models::Coordinate.create(
          uuid:       point[:uuid],
          timestamp:  DateTime.parse(point[:date]),
          altitude:   point[:location][:position][:altitude],
          speed:      point[:location][:position][:speed],
          heading:    point[:location][:position][:heading],
          h_accuracy: point[:location][:position][:horizontal_accuracy],
          v_accuracy: point[:location][:position][:vertical_accuracy],

          location: {
            lat: point[:location][:position][:latitude],
            lng: point[:location][:position][:longitude]
          }
        )
      end
    end

  end
end
