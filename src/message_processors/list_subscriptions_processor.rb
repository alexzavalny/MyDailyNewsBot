require "./src/message_processors/base_processor"

module MessageProcessors
  class ListSubscriptionsProcessor < BaseProcessor
    def process
      subscriptions = Subscription.where(chat_id: message.chat.id)

      if subscriptions.empty?
        send_text(Texts.no_subscriptions)
      else
        # Show the user's subscriptions
        reply_message = "#{Texts.your_subscription}\n"
        subscriptions.each_with_index do |subscription, index|
          reply_message += "🗞 #{index + 1}. #{subscription.website_name} (#{subscription.feed_url}) \n"
        end

        send_text(reply_message)
      end
    end
  end
end
