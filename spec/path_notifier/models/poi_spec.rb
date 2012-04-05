require 'spec_helper'

module PathNotifier
  module Models
    describe POI do
      it 'detects clusters of activity' do
        data = [
          {lat:  1.000,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  0, 00)},
          {lat:  1.001,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  1, 03)},
          {lat:  1.001,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  2, 00)},
          {lat:  1.002,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  3, 00)},
          {lat:  1.018,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  4, 00)},
          {lat:  1.002,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  5, 00)},
          {lat:  1.000,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  6, 00)},
          {lat:  1.001,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  7, 00)},
          {lat:  1.000,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  8, 00)},
          {lat:  1.003,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14,  9, 00)},
          {lat: 12.000,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14, 10, 00)},
          {lat:  1.000,  long: 1.0, timestamp: Time.gm(2012, 01, 01, 14, 11, 00)}
        ]

        data.each do |i|
          Coordinate.safely.create(location: {lat: i[:lat], lng: i[:long]}, timestamp: i[:timestamp])
        end

        POI.detect_clusters.should have(3).groups
      end

      it 'is not slow for massive amounts of data' do
        puts "Generating data"
        10000.times do
          Coordinate.safely.create(location: {lat: 1 + Random.rand, lng: 1 + Random.rand}, 
                                   timestamp: Time.now)
        end

        puts Time.now
        POI.detect_clusters
        puts Time.now
      end
    end
  end
end
