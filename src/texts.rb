module Texts
  class << self
    def welcome; "Welcome to My Daily News bot! Use /subscribe to subscribe to a news website."; end;
    def no_subscriptions; "You have no subscriptions."; end;
    def enter_rss; "Please enter the RSS feed URL:"; end;
    def subscription_limit_reached; "You have reached the maximum number of subscriptions."; end;
    def select_subscription; "Please select a subscription to unsubscribe:"; end;
    def your_subscription; "Your subscriptions:"; end;
  end
end