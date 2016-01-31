require 'json'
require 'faraday'
module GHStreaksBot
  SERVICE_BASEURL = 'https://ghstreaks-service.herokuapp.com'

  class GHUserNotFoundError < Exception; end

  class Service
    def search_notifications(time)
      json = Faraday.get("#{SERVICE_BASEURL}/notifications/search?hour=#{time.hour}").body
      JSON.parse(json)
    end

    def current_streaks(user)
      response = Faraday.get("#{SERVICE_BASEURL}/streaks/#{user}")
      raise GHUserNotFoundError unless response.status == 200
      json = JSON.parse(response.body)
      json['current_streaks']
    end
  end
end
