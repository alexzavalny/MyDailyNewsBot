module MessageProcessors
  class SubscribeProcessor < BaseProcessor
    def feed_url
      @conversation.listen do |message|
        p message.text
        break message.text if !message.nil? && message.text.start_with?("http")

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
        puts "Parsing feed #{url}"
        feed_title, article_url = FeedUtils.get_feed_title_from_url(url)

        if Subscription.where(chat_id: @conversation.chat_id, feed_url: url).exists?
          @conversation.reply("You are already subscribed to #{feed_title} news.")
          return
        end

        # Create a new subscription in the database
        Subscription.create(
          chat_id: @conversation.chat_id,
          feed_url: url,
          website_name: feed_title,
          last_update_at: Time.now
        )

        @conversation.reply("You are now subscribed to #{feed_title} news. Last article:\n")
        @conversation.reply(article_url)
      rescue Feedjira::NoParserAvailable
        @conversation.reply(Texts.seems_like_not_rss)
        rss_link = FeedUtils.find_feed_url_on_page(url)

        if rss_link
          @conversation.reply("I found a link to RSS feed: #{rss_link}")
          url = rss_link
          retry
        else
          @conversation.reply("I cannot find a link to RSS feed. Please try again.")
        end
      rescue
        @conversation.reply(Texts.invalid_rss)
      end
    end
  end
end
