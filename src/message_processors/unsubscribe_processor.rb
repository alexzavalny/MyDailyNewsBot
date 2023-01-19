module MessageProcessors
  class UnsubscribeProcessor < BaseProcessor
    def process
      # Get the user's subscriptions
      subscriptions = Subscription.where(chat_id: message.chat.id)

      if subscriptions.empty?
        send_text(Texts.no_subscriptions)
      else
        # Show the user's subscriptions
        reply_message = Texts.select_subscription + "\n"
        subscriptions.each_with_index do |subscription, index|
          reply_message += "#{index + 1}. #{subscription.website_name}\n"
        end

        send_text(reply_message)

        # Get the selected subscription
        selected_subscription = bot.listen do |message|
          subscription_index = message.text.to_i - 1
          break subscriptions[subscription_index] if (0...subscriptions.length).cover?(subscription_index)
        end

        # Delete the selected subscription from the database
        selected_subscription.destroy

        send_text("You are now unsubscribed from #{selected_subscription.website_name} news.")
      end
    end
  end
end
