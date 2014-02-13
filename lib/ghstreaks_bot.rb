require 'zero_push'
require 'active_support/all'
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
    return if notification['device_token'].blank?

    ZeroPush.notify({
      device_tokens: [notification['device_token']],
      alert: 'Shut the fuck up and write some code!.',
      sound: "default",
      badge: badge
    })
  end

end
