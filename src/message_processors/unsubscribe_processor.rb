module MessageProcessors
  class UnsubscribeProcessor < BaseProcessor
    def read_subscription_number
      # Get the selected subscription
      @conversation.listen do |message|
        if !message.text.integer?
          @conversation.reply(Texts.you_entered_not_a_number)
        elsif message.text.to_i - 1 >= subscriptions.length
          @conversation.reply(Texts.invalid_number)
        else
          break message.text.to_i - 1
        end
      end
    end

    def subscriptions
      @subscriptions ||= Subscription.where(chat_id: @conversation.chat_id)
    end

    def compose_subscription_list
      reply_message = "#{Texts.select_subscription}\n\n"
      subscriptions.each_with_index do |subscription, index|
        reply_message += "#{index + 1}. #{subscription.website_name}\n"
      end
      reply_message
    end

    def process
      if subscriptions.empty?
        @conversation.reply(Texts.no_subscriptions)
      else
        @conversation.reply(compose_subscription_list)

        selected_subscription = subscriptions[read_subscription_number]
        selected_subscription.destroy

        @conversation.reply("You are now unsubscribed from #{selected_subscription.website_name} news.")
      end
    end
  end
end
