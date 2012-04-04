require 'spec_helper'

module PathNotifier
  module Models
    describe POI do
      it 'detects clusters of activity' do
        data = [
          {lat: 1.0,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  0, 00)},
          {lat: 1.1,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  1, 03)},
          {lat: 1.1,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  2, 00)},
          {lat: 1.2,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  3, 00)},
          {lat: 1.3,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  4, 00)},
          {lat: 1.2,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  5, 00)},
          {lat: 1.0,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  6, 00)},
          {lat: 1.1,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  7, 00)},
          {lat: 1.0,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  8, 00)},
          {lat: 1.3,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  9, 00)},
          {lat: 12.0, long: 1.0, timestamp: Time.gm(2012, 01, 01, 14, 10, 00)},
          {lat: 1.0,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14, 11, 00)}
        ]

        data.each do |i|
          Coordinate.safely.create(location: {lat: i[:lat], lng: i[:long]}, timestamp: i[:timestamp])
        end

        Coordinate
      end
    end
  end
end
