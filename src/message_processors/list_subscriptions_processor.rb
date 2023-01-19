require "./src/message_processors/base_processor"

module MessageProcessors
  class ListSubscriptionsProcessor < BaseProcessor
    def subscriptions
      @subscriptions ||= Subscription.where(chat_id: message.chat.id)
    end

    def compose_reply
      return Texts.no_subscriptions if subscriptions.empty?

      # Show the user's subscriptions
      "#{Texts.your_subscription}\n\n" +
        subscriptions.map_with_index do |subscription, index|
          "🗞 #{index + 1}. #{subscription.name_with_url}\n"
        end
    end
  end
end
