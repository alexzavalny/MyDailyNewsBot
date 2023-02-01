require "telegram/bot"
require "active_record"
require "feedjira"
require "httparty"

module Jobs
  class SubscriptionJob
    def initialize(client: Telegram::Bot::Client, token: Config.token)
      @client = client
      @token = token
    end

    def start
      puts "Job started..."

      loop do
        begin
          @client.run(@token) do |bot|
            Subscription.all.each do |sub|
              chat_id = sub.chat_id
              feed_url = sub.feed_url
              last_update_at = sub.last_update_at

              puts "Checking feed #{feed_url}"
              feed = nil
              begin
                xml = HTTParty.get(feed_url).body
                feed = Feedjira.parse(xml)
              rescue
                puts "Error parsing feed #{feed_url}"
              end

              next if feed.nil?

              first = true
              next unless feed

              feed.entries.each do |entry|
                next unless entry.published > last_update_at

                bot.api.send_message(chat_id: chat_id, text: format_message(sub, entry), parse_mode: "Markdown")
                sub.update(last_update_at: entry.published) if first
                first = false
              end
            end
          end

          sleep Config.sleep_time
        end
      rescue
      end
    end

    private

    def format_message(subscription, entry)
      "*#{subscription.website_name}*\n#{entry.title}\n\n#{entry.url}"
      # "#{entry.title}\n\n#{entry.url}"
    end
  end
end
