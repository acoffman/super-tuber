class SubscribeToFeed
  include FeedHelpers

  attr_reader :target_url, :errors

  def initialize(target_url: )
    @target_url = target_url
    @errors = []
  end

  def perform
    channel_id = extract_channel_id(url: target_url)
    return if channel_id.nil?
    feed = fetch_feed(channel_id: channel_id)
    return if feed.nil?

    if channel = Channel.find_by(youtube_channel_id: channel_id)
      errors << 'Already subscribed to this channel'
      return channel
    end

    channel = Channel.create(
      youtube_channel_id: channel_id,
      youtube_url: feed.url,
      feed_url: feed.feed_url,
      name: feed.title,
    )

    if channel.errors.any?
      errors = channel.errors.full_messages
      return
    end

    return channel
  end

  def extract_channel_id(url: )
    body = HTTParty.get(url).body rescue nil

    if body.nil?
      errors << 'Failed to fetch video URL'
      return
    end

    doc = Nokogiri::HTML(body)
    res = doc.at("meta[itemprop='channelId']")
    if res
      res['content']
    else
      errors << 'Failed to find Channel Id for URL'
      nil
    end
  end
end
