module PathNotifier
  class App < Sinatra::Base
    post '/coordinates' do
      coordinate = Models::Coordinate.create(params[:coordinate])
      return coordinate.to_json
    end
  end
end
