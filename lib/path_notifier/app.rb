module PathNotifier
  class App < Sinatra::Base
    get '/' do
      erb :map
    end

    post '/coordinates' do
      coordinate = Models::Coordinate.create(params[:coordinate])
      return coordinate.to_json
    end
  end
end
