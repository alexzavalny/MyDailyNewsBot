require "feedjira"
require "httparty"
require "byebug"
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

      rss_xml = get_link(doc, "link[type='application/rss+xml']")
      return combine_url(url, rss_xml) if rss_xml

      atom_xml = get_link(doc, "link[type='application/atom+xml']")
      return combine_url(url, atom_xml) if atom_xml

      nil
    rescue StandardError => e
      p e
      nil
    end

    private
    def get_link(doc, path)
      links = doc.css(path)
      if links.first && links.first["href"]
        return links.first["href"]
      end
    end

    def relative_url?(url)
      url.start_with?("/")
    end

    def combine_url(base_url, url)
      p base_url
      p url
      return url unless relative_url?(url)

      base_url + url
    end
  end
end
