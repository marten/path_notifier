module PathNotifier
  class App < Sinatra::Base
    get '/' do
      @last_location = Models::Coordinate.last
      @coordinates = Models::Coordinate.all
      @groups = @coordinates.group_by {|i| [i.timestamp.year, i.timestamp.month, i.timestamp.day] }
      @places   = Models::Place.all
      erb :map
    end

    get '/routes.json' do
			@coordinates = Models::Coordinate.all
			@groups = @coordinates.group_by {|i| [i.timestamp.year, i.timestamp.month, i.timestamp.day].join('-') }
			return @groups.to_json
		end

		get '/pois.json' do
			@pois   = Models::POI.all
			return @pois.to_json
		end

		get '/places.json' do
      @places   = Models::Place.all
      return @places.to_json
		end

    post '/coordinates' do
      coordinate = Models::Coordinate.create(params[:coordinate])
      return coordinate.to_json
    end
  end
end
