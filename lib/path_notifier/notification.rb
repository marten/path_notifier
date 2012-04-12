module PathNotifier
  class Notification
    def self.session
      @session ||= Geoloqi::Session.new :access_token => ENV['GEOLOQI_TOKEN']
    end

    def self.for(place)
      self.new("Tasks nearby: #{place.tasks.join('; ')}")
    end

    def initialize(message, url = nil)
      @message = message
      @url = url
    end

    def send
      self.class.session.post('message/send', text: @message, url: @url)
    end
  end
end
