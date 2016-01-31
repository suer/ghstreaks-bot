require 'houston'
require 'logger'
$: << "."
require 'ghstreaks_bot/service'


module GHStreaksBot

  @logger = Logger.new(STDOUT)
  @logger.level = Logger::INFO

  def self.run
    client = Houston::Client.production
    client.certificate = ENV['APNS_PEM']
    service = GHStreaksBot::Service.new
    notifications = service.search_notifications(Time.now.utc)
    notifications.each do |notification|
      begin
        current_streaks = service.current_streaks(notification['user_name'])
        push_notification(client, notification, current_streaks)
      rescue GHStreaksBot::GHUserNotFoundError
        @logger.error("User #{notification['user_name']} not found")
      end
    end
  end

  private
  def self.push_notification(client, notification, badge)
    device_token = notification['device_token']
    return if device_token.nil? or device_token == ''

    client.push(Houston::Notification.new({
      device: device_token,
      alert: 'Shut the fxxk up and write some code!',
      sound: 'default',
      badge: badge}))

    @logger.info("Notification pushed: token #{notification['device_token']}, user_name #{notification['user_name']}, badge #{badge}")
  end

end
