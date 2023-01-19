require "feedjira"
require "httparty"

class FeedUtils
  class << self
    def get_feed_title_from_url(url)
      xml = HTTParty.get(url).body
      feed = Feedjira.parse(xml)
      [feed.title.strip, feed.entries.first.url]
    end

    def find_feed_url_on_page(url)
      response = HTTParty.get(url)
      doc = Nokogiri::HTML(response.body)
      doc.css("link[type='application/rss+xml']").first["href"]
    rescue
      nil
    end
  end
end
