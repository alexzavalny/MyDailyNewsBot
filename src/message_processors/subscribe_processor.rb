module MessageProcessors
  class SubscribeProcessor < BaseProcessor
    def feed_url
      bot.listen do |message|
        break message.text if message.text.start_with?("http")

        send_text(Texts.you_entered_not_a_url)
      end
    end

    def process
      # Check if the user has reached the subscription limit
      if Subscription.where(chat_id: message.chat.id).count >= Config.subscription_limit
        send_text(Texts.subscription_limit_reached)
        return
      end

      # Get the RSS feed URL from the user
      send_text(Texts.enter_rss)
      url = feed_url

      # Parse the RSS feed
      begin
        feed_title, article_url = FeedUtils.get_feed_title_from_url(url)

        # Create a new subscription in the database
        Subscription.create(
          chat_id: message.chat.id,
          feed_url: url,
          last_update_at:
          Time.current,
          website_name: feed_title
        )

        send_text("You are now subscribed to #{feed_title} news. Last article:\n")
        send_text(article_url)
      rescue StandardError
        send_text(Texts.invalid_rss)
      end
    end
  end
end
