module MessageProcessors
  class UnsubscribeProcessor < BaseProcessor
    def process
      return if check_no_subscriptions?

      @conversation.reply(compose_subscription_list)
      @conversation.reply_with_keyboard(compose_keyboard)
      puts "replied with keyboard"
      subscription_number = read_subscription_number
      puts "read subscription number"
      return if check_cancel?(subscription_number)

      selected_subscription = subscriptions[subscription_number]
      selected_subscription.destroy

      @conversation.reply("You are now unsubscribed from #{selected_subscription.website_name} news.")
    end

    private

    def check_cancel?(subscription_number)
      return false if subscription_number > -1
      @conversation.reply(Texts.canceled)
      true
    end

    def check_no_subscriptions?
      return false unless subscriptions.empty?

      @conversation.reply(Texts.no_subscriptions)
      true
    end

    def read_subscription_number
      # Get the selected subscription
      @conversation.listen do |message|
        p "message: #{message}"
        if message.text == "zero"
          break -1
        elsif !message.text.integer?
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

    def compose_keyboard
      keyboard = []
      subscriptions.each_with_index do |subscription, index|
        keyboard << [{text: "#{index + 1}. #{subscription.website_name}", callback_data: "/unsubscribe #{index + 1}"}]
      end
      keyboard << [{text: "Cancel", callback_data: "0"}]
      keyboard
    end

    def compose_subscription_list
      reply_message = "#{Texts.select_subscription}\n\n"
      subscriptions.each_with_index do |subscription, index|
        reply_message += "#{index + 1}. #{subscription.website_name}\n"
      end
      reply_message
    end
  end
end
