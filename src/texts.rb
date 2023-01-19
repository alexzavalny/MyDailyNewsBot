module Texts
  class << self
    def welcome
      "Welcome to News Tornado bot! Use /subscribe to subscribe to a news website."
    end

    def no_subscriptions
      "You have no subscriptions."
    end

    def enter_rss
      "Please enter the RSS feed URL:"
    end

    def subscription_limit_reached
      "You have reached the maximum number of subscriptions."
    end

    def select_subscription
      "Please select a subscription to unsubscribe:"
    end

    def your_subscription
      "Your subscriptions:"
    end

    def invalid_rss
      "Invalid RSS feed URL. (I still cannot find RSS feed myself. Please send a link to the feed, not to the website."
    end

    def unknown_command
      "Very interesting, but I don't know what to do with it. Try /help."
    end

    def available_commands
      "Available commands: \n/start\n/subscribe\n/unsubscribe\n/list_subscriptions\n/help\n/catalog"
    end

    def catalog_is_empty
      "Catalog is empty, but we are working on it. Stay tuned"
    end
  end
end
