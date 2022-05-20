class RefreshFeed
  include FeedHelpers

  attr_reader :channel, :errors

  def initialize(channel: )
    @errors = []
    @channel = channel
  end

  def perform
    feed = fetch_feed(channel_id: channel.youtube_channel_id)
    return if feed.nil?

    if channel.feed_last_modified.nil? || channel.feed_last_modified != feed.last_modified
      update_channel_from_feed(channel: channel, feed: feed)
    end

    if errors.empty?
      channel.update!(
        last_fetch_status: :success,
        feed_last_modified: feed.last_modified,
        last_fetch_attempt: DateTime.now
      )
    else
      channel.update!(
        last_fetch_status: :failure,
        last_fetch_attempt: DateTime.now
      )
    end
  end

  def update_channel_from_feed(channel:, feed:)
    feed.entries.each do |entry|
      existing_video = Video.find_by(youtube_video_id: entry.youtube_video_id)
      if existing_video
        existing_video.update!(
          video_updated_at: entry.updated,
          youtube_url: entry.media_url,
          thumbnail_url: entry.media_thumbnail_url,
          title: entry.media_title,
          description: entry.content
        ) if entry.updated != existing_video.video_updated_at
      else
        Video.create!(
          youtube_video_id: entry.youtube_video_id,
          youtube_url: entry.media_url,
          thumbnail_url: entry.media_thumbnail_url,
          title: entry.media_title,
          description: entry.content,
          video_published_at: entry.published,
          video_updated_at: entry.updated,
          channel: channel,
          status: :unseen
        )
      end
    end
  end
end
