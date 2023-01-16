require 'telegram/bot'
require 'active_record'
require 'feedjira'
require 'httparty'
require './src/config.rb'
require './src/feed.rb'
require './models/subscription.rb'

# Connect to the database using Active Record
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.sqlite3'
)

puts "Starting telegram bot"

# Initialize the Telegram bot
Telegram::Bot::Client.run(Config.get_token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Welcome to My Daily News bot! Use /subscribe to subscribe to a news website.")
    when '/list_subscriptions'
      # Get the user's subscriptions
      subscriptions = Subscription.where(chat_id: message.chat.id)

      unless subscriptions.empty?
        # Show the user's subscriptions
        reply_message = "Your subscriptions:\n"
        subscriptions.each do |subscription|
          reply_message += "#{subscription.website_name}\n"
        end
        
        bot.api.send_message(chat_id: message.chat.id, text: reply_message)
      else
        bot.api.send_message(chat_id: message.chat.id, text: "You have no subscriptions.")
      end
    when '/subscribe'
      # Check if the user has reached the subscription limit
      if Subscription.where(chat_id: message.chat.id).count >= Config.get_subscription_limit
        bot.api.send_message(chat_id: message.chat.id, text: "You have reached your subscription limit.")
      else
        # Get the RSS feed URL from the user
        bot.api.send_message(chat_id: message.chat.id, text: "Please enter the RSS feed URL:")
        url = bot.listen do |message|
          break message.text if message.text.start_with?("http")
        end

        # Parse the RSS feed
        feed_title = Feed.get_feed_title_from_url(url)

        # Create a new subscription in the database
        Subscription.create(chat_id: message.chat.id, feed_url: url, last_update_at: Time.now, website_name: feed_title)

        bot.api.send_message(chat_id: message.chat.id, text: "You are now subscribed to #{feed_title} news.")
      end
    when '/unsubscribe'
      # Get the user's subscriptions
      subscriptions = Subscription.where(chat_id: message.chat.id)

      if subscriptions.empty?
        bot.api.send_message(chat_id: message.chat.id, text: "You have no subscriptions.")
      else
        # Show the user's subscriptions
        reply_message = "Please select a subscription to unsubscribe:\n"
        subscriptions.each_with_index do |subscription, index|
          reply_message += "#{index + 1}. #{subscription.website_name}\n"
        end

        bot.api.send_message(chat_id: message.chat.id, text: reply_message)

        # Get the selected subscription
        selected_subscription = bot.listen do |message|
          subscription_index = message.text.to_i - 1
          break subscriptions[subscription_index] if (0...subscriptions.length).cover?(subscription_index)
        end

        # Delete the selected subscription from the database
        selected_subscription.destroy

        bot.api.send_message(chat_id: message.chat.id, text: "You are now unsubscribed from #{selected_subscription.website_name} news.")
      end
    end
  end
end
