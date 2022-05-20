module FeedHelpers
  def fetch_feed(channel_id: )
    url = "https://www.youtube.com/feeds/videos.xml?channel_id=#{channel_id}"
    feed_body = HTTParty.get(url).body rescue nil
    if feed_body.nil?
      errors << 'Failed to fetch the feed'
      return
    end
    feed = Feedjira.parse(feed_body)
  end
end
