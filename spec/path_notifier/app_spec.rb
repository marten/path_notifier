require 'spec_helper'

module PathNotifier
  describe App do
    describe 'POST /coordinates' do
      it 'should return an OK status' do
        post '/coordinates', :coordinate => {location: {lat: 1, lng: 4}}
        last_response.should be_ok
      end

      it 'should save a coordinate' do
        post '/coordinates', :coordinate => {location: {lat: 1, lng: 4}}
        Models::Coordinate.count.should == 1
      end
    end
  end
end

