module PathNotifier
  class App < Sinatra::Base
    configure :production, :development do
      enable :logging
    end

    before do
      format = %{[%s] %s - "%s %s%s %s" %d}
      logger.info format % [
        Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-",
        env["REQUEST_METHOD"],
        env["PATH_INFO"],
        env["QUERY_STRING"].empty? ? "" : "?"+env["QUERY_STRING"],
        env["HTTP_VERSION"],
        status.to_s[0..3]
      ]
    end

    get '/' do
      @last_location = Models::Coordinate.last
      erb :map
    end

    get '/tracks.json' do
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

		get '/routes.json' do
      @routes   = Models::Route.all
      return @routes.to_json
		end

    get '/test-trigger/:place_id' do |place_id|
      place = Models::Place.find(params[:place_id])
      notification = Notification.for(place)
      return notification.send.to_json
    end

		post '/geoloqi-callback' do
			puts "Callback received"
			result = LocationTrigger.trigger.to_json
			puts "Result: #{result}"
			result
		end

    post '/coordinates' do
      coordinate = Models::Coordinate.create(params[:coordinate])
      return coordinate.to_json
    end
  end
end
