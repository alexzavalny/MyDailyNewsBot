require "./src/message_processors/base_processor"

module MessageProcessors
  class ListSubscriptionsProcessor < BaseProcessor
    def subscriptions
      @subscriptions ||= Subscription.where(chat_id: @conversation.chat_id)
    end

    def compose_subscriptions
      "#{Texts.your_subscription}\n\n" +
        subscriptions.to_a.map_with_index do |subscription, index|
          "🗞 #{index + 1}. #{subscription.name_with_url}\n"
        end.join
    end

    def process
      @conversation.reply(subscriptions.empty? ? Texts.no_subscriptions : compose_subscriptions)
    end
  end
end
