module MessageProcessors
  class UnsubscribeProcessor < BaseProcessor
    def read_subscription_number
      # Get the selected subscription
      bot.listen do |message|
        if !message.text.integer?
          send_text(Texts.you_entered_not_a_number)
        elsif message.text.to_i - 1 >= subscriptions.length
          send_text(Texts.invalid_number)
        else
          break message.text.to_i - 1
        end
      end
    end

    def subscriptions
      @subscriptions ||= Subscription.where(chat_id: message.chat.id)
    end

    def compose_subsription_list
      reply_message = "#{Texts.select_subscription}\n\n"
      subscriptions.each_with_index do |subscription, index|
        reply_message += "#{index + 1}. #{subscription.website_name}\n"
      end
      reply_message
    end

    def process
      if subscriptions.empty?
        send_text(Texts.no_subscriptions)
      else
        send_text(compose_subsription_list)

        selected_subscription = subscriptions[read_subscription_number]
        selected_subscription.destroy

        send_text("You are now unsubscribed from #{selected_subscription.website_name} news.")
      end
    end
  end
end
