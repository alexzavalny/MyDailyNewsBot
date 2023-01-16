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

class CheckFeedWorker
  include Sidekiq::Worker

  def perform
    Telegram::Bot::Client.run(TOKEN) do |bot|
      Subscription.all.each do |sub|
        chat_id = sub.chat_id
        feed_url = sub.feed_url
        last_update_at = sub.last_update_at
        feed = Feedjira::Feed.fetch_and_parse(feed_url)
        if feed
          feed.entries.each do |entry|
            if entry.published > last_update_at
              bot.api.send_message(chat_id: chat_id, text: "New link in #{feed_url} : #{entry.url}")
              sub.update(last_update_at: entry.published)
            end
          end
        end
      end
    end
  end
end