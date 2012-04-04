module PathNotifier
  class App < Sinatra::Base
    get '/' do
      erb "<h2>Hello There, buddy!</h2>"
    end
  end
end
