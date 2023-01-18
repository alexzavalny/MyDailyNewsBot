require 'feedjira'
require 'httparty'

module Feed
  def self.get_feed_title_from_url(url)
    xml = HTTParty.get(url).body
    feed = Feedjira.parse(xml)
    [feed.title.strip, feed.entries.first.url]
  end
end
