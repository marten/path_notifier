module PathNotifier
  class App < Sinatra::Base
    get '/' do
      @last_location = Models::Coordinate.last
      erb :map
    end

    get '/history.kml' do
        
    end

    post '/coordinates' do
      coordinate = Models::Coordinate.create(params[:coordinate])
      return coordinate.to_json
    end
  end
end
