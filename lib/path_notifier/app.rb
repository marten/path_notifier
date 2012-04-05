module PathNotifier
  class App < Sinatra::Base
    get '/' do
      @last_location = Models::Coordinate.last
      @coordinates = Models::Coordinate.all
      erb :map
    end

    post '/coordinates' do
      coordinate = Models::Coordinate.create(params[:coordinate])
      return coordinate.to_json
    end
  end
end
