require 'json'
module GHStreaksBot
  SERVICE_BASEURL = 'https://ghstreaks-service.herokuapp.com'

  class GHUserNotFoundError < Exception; end

  class Service
    def search_notifications(time)
      json = Faraday.get("#{SERVICE_BASEURL}/notifications/search").body
      notifications = JSON.parse(json)
      notifications.delete_if do |notification|
        get_hour_with_timezone(notification) != time.hour
      end
    end

    def current_streaks(user)
      response = Faraday.get("#{SERVICE_BASEURL}/streaks/#{user}")
      raise GHUserNotFoundError unless response.status == 200
      json = JSON.parse(response.body)
      json['current_streaks']
    end

    private
    def get_hour_with_timezone(notification)
      hour = notification['hour'].to_i
      timezone = notification['timezone']
      hour_with_timezone = hour - ActiveSupport::TimeZone[timezone].utc_offset / 3600
      hour_with_timezone % 24
    end
  end
end
