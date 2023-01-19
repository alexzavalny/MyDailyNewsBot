require "telegram/bot"
require "active_record"
require "feedjira"
require "httparty"
require "./src/config"
require "./src/feed"
require "./models/subscription"
require "./src/db_connection"

# class CheckFeedWorker
#   include Sidekiq::Worker

#   def perform

puts "Job started..."

loop do
  Telegram::Bot::Client.run(Config.token) do |bot|
    Subscription.all.each do |sub|
      chat_id = sub.chat_id
      feed_url = sub.feed_url
      last_update_at = sub.last_update_at

      puts "Checking feed #{feed_url}"
      feed = nil
      begin
        xml = HTTParty.get(feed_url).body
        feed = Feedjira.parse(xml)
      rescue e
        p e
        puts "Error parsing feed #{feed_url}"
      end

      next if feed.nil?

      first = true
      next unless feed

      feed.entries.each do |entry|
        next unless entry.published > last_update_at

        bot.api.send_message(chat_id: chat_id, text: entry.url)
        sub.update(last_update_at: entry.published) if first
        first = false
      end
    end
  end

  sleep Config.sleep_time
end
