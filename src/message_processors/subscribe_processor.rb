module MessageProcessors
  class SubscribeProcessor < BaseProcessor
    def process
      return if check_limit_reached?
      return if check_not_url?

      process_url(@conversation.command)
    end

    private

    def listen_for_feed_url
      @conversation.listen do |message|
        p message.text
        break message.text if !message.nil? && message.text.start_with?("http")

        @conversation.reply(Texts.you_entered_not_a_url)
      end
    end

    def check_not_url?
      return false if @conversation.command.is_url?
      @conversation.reply(Texts.enter_rss)
      true
    end

    def check_limit_reached?
      # Check if the user has reached the subscription limit
      return false if !Subscription.reached(chat_id: @conversation.chat_id, count: Config.subscription_limit)

      send_text(Texts.subscription_limit_reached)
      true
    end

    def check_already_subscribed?(url)
      # Check if the user is already subscribed to this feed
      return false unless Subscription.exists?(chat_id: @conversation.chat_id, feed_url: url)

      @conversation.reply(Texts.already_subscribed)
      true
    end

    def check_no_feed?(rss_link)
      return false if !rss_link.nil?

      @conversation.reply(Texts.cannot_find_link)
      true
    end

    def process_url(url)
      # Parse the RSS feed

      return if check_already_subscribed?(url)

      puts "Parsing feed #{url}"

      feed_title, article_url = FeedUtils.get_feed_title_from_url(url)

      # Create a new subscription in the database
      Subscription.create(
        chat_id: @conversation.chat_id,
        feed_url: url,
        website_name: feed_title,
        last_update_at: Time.now
      )

      @conversation.reply(Texts.successfully_subscribed(feed_title))
      @conversation.reply(article_url)
    rescue Feedjira::NoParserAvailable
      rss_link = FeedUtils.find_feed_url_on_page(url)

      return if check_no_feed?(rss_link)

      @conversation.reply(Texts.found_link(rss_link))
      url = rss_link
      retry
    rescue => e
      puts e
      @conversation.reply(Texts.invalid_rss)
    end
  end
end
