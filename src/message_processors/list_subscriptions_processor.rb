require "./src/message_processors/base_processor"

module MessageProcessors
  class ListSubscriptionsProcessor < BaseProcessor
    def compose_reply
      subscriptions = Subscription.where(chat_id: message.chat.id)

      return Texts.no_subscriptions if subscriptions.empty?

      # Show the user's subscriptions
      reply_message = "#{Texts.your_subscription}\n"
      subscriptions.each_with_index do |subscription, index|
        reply_message += "🗞 #{index + 1}. #{subscription.website_name} (#{subscription.feed_url}) \n"
      end
      reply_message
    end

    def process
      send_text(compose_reply)
    end
  end
end
