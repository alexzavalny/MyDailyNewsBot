require 'feedjira'
require 'httparty'

module Feed
  def self.get_feed_title_from_url(url)
    xml = HTTParty.get(url).body
    feed = Feedjira.parse(xml)
    feed.title
  end
end