class PushNotificationJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(question)
    message = {
        title: 'New answer',
        body: "New answer for question #{question}. CLick to view it.",
        icon: 'https://nimbl3.com/assets/image/favicon.ico?1399950378',
        open_url: question_path(question)
    }

    subscriptions = Subscription.all

    subscriptions.each do |subscription|
      Webpush.payload_send(
        endpoint: subscription.endpoint,
        message: JSON.generate(message),
        p256dh: subscription.key_p256dh,
        auth: subscription.key_auth,
        api_key: ENV.fetch('FIRE_BASE_API_KEY')
      )
    end
  end
end
