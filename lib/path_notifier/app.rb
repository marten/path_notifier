module PathNotifier
  class App < Sinatra::Base
    get '/' do
      @last_location = Models::Coordinate.last
      @coordinates = Models::Coordinate.all
      @groups = @coordinates.group_by {|i| [i.timestamp.year, i.timestamp.month, i.timestamp.day] }
      erb :map
    end

    post '/coordinates' do
      coordinate = Models::Coordinate.create(params[:coordinate])
      return coordinate.to_json
    end
  end
end
