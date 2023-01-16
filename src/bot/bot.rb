require 'telegram/bot'
require 'active_record'
require 'feedjira'

# Connect to the database using Active Record
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'subscriptions.sqlite3'
)

# Define the Subscription model
class Subscription < ActiveRecord::Base
end

# Define the maximum number of subscriptions per user
SUBSCRIPTION_LIMIT = 5
TOKEN = "5848650600:AAH4WWDuYMqSwbB90WZx_59n9Scqe_wAoqA"

# Initialize the Telegram bot
Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Welcome to My Daily News bot! Use /subscribe to subscribe to a news website.")
    when '/subscribe'
      # Check if the user has reached the subscription limit
      if Subscription.where(chat_id: message.chat.id).count >= SUBSCRIPTION_LIMIT
        bot.api.send_message(chat_id: message.chat.id, text: "You have reached your subscription limit.")
      else
        # Get the RSS feed URL from the user
        bot.api.send_message(chat_id: message.chat.id, text: "Please enter the RSS feed URL:")
        url = bot.listen do |message|
          break message.text if message.text.start_with?("http")
        end

        # Parse the RSS feed
        feed = Feedjira::Feed.fetch_and_parse(url)

        # Create a new subscription in the database
        subscription = Subscription.create(chat_id: message.chat.id, rss_feed_url: url, last_read_article_date: Time.now, website_name: feed.title)

        bot.api.send_message(chat_id: message.chat.id, text: "You are now subscribed to #{feed.title} news.")
      end
    when '/unsubscribe'
      # Get the user's subscriptions
      subscriptions = Subscription.where(chat_id: message.chat.id)

      if subscriptions.empty?
        bot.api.send_message(chat_id: message.chat.id, text: "You have no subscriptions.")
      else
        # Show the user's subscriptions
        message = "Please select a subscription to unsubscribe:\n"
        subscriptions.each_with_index do |subscription, index|
          message += "#{index + 1}. #{subscription.website_name}\n"
        end

        bot.api.send_message(chat_id: message.chat.id, text: message)

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