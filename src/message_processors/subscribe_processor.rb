module MessageProcessors
  class SubscribeProcessor < BaseProcessor
    def feed_url
      @conversation.listen do |message|
        break message.text if message.text.start_with?("http")

        @conversation.reply(Texts.you_entered_not_a_url)
      end
    end

    def process
      # Check if the user has reached the subscription limit
      if Subscription.where(chat_id: @conversation.chat_id).count >= Config.subscription_limit
        send_text(Texts.subscription_limit_reached)
        return
      end

      # Get the RSS feed URL from the user
      @conversation.reply(Texts.enter_rss)
      url = feed_url

      # Parse the RSS feed
      begin
        feed_title, article_url = FeedUtils.get_feed_title_from_url(url)

        # Create a new subscription in the database
        Subscription.create(
          chat_id: @conversation.chat_id,
          feed_url: url,
          website_name: feed_title
        )

        @conversation.reply("You are now subscribed to #{feed_title} news. Last article:\n")
        @conversation.reply(article_url)
      rescue Feedjira::NoParserAvailable
        @conversation.reply(Texts.invalid_rss)
      rescue StandardError
        @conversation.reply(Texts.invalid_rss)
      end
    end
  end
end
