require 'zero_push'
$: << "."
require 'ghstreaks_bot/service'

ZeroPush.auth_token = ENV['ZEROPUSH_AUTH_TOKEN']

module GHStreaksBot

  def self.run
    service = GHStreaksBot::Service.new
    notifications = service.search_notifications(Time.now.utc)
    notifications.each do |notification|
      begin
        current_streaks = service.current_streaks(notification['user_name'])
        push_notification(notification, current_streaks)
      rescue GHStreaksBot::GHUserNotFoundError
        # log
      end
    end
  end

  private
  def self.push_notification(notification, badge)
    device_token = notification['device_token']
    return if device_token.nil? or device_token == ''

    ZeroPush.notify({
      device_tokens: [device_token],
      alert: 'Shut the fuck up and write some code!.',
      sound: "default",
      badge: badge
    })
  end

end
