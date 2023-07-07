class SubscribeToFeed
  include FeedHelpers

  attr_reader :target_url, :errors

  def initialize(target_url: )
    @target_url = target_url
    @errors = []
  end

  def perform
    doc = fetch_and_parse(url: target_url)
    if doc
      thumbnail_url = extract_thumnail_url(document: doc)
      channel_id = extract_channel_id(document: doc)
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
  end

  def extract_thumnail_url(document: )
    res = document.at("img[id='img']")
  end

  def extract_channel_id(document: )
    res = document.at("meta[itemprop='channelId']")
    if res
      res['content']
    else
      errors << 'Failed to find Channel Id for URL'
      nil
    end
  end

  def fetch_and_parse(url: )
    body = HTTParty.get(url).body rescue nil

    if body.nil?
      errors << 'Failed to fetch video URL'
      return
    end

    return Nokogiri::HTML(body)
  end
end
