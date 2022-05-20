class ChannelsController < ApplicationController
  before_action :ensure_logged_in
  before_action :set_channel

  def index
    query = if params[:filter]
              Channel.where('name LIKE ?', "%#{params[:filter]}%")
            else
              Channel.all
            end
    @pagy, @channels = pagy(query,  link_extra: 'data-turbo-frame="content" data-turbo-action="advance"')
    @selected = 'channels'
    @is_filter_request = params[:filter_request]
  end

  def create
    cmd = SubscribeToFeed.new(target_url: params[:target_url])
    @channel = cmd.perform
    if cmd.errors.any?
      @errors = cmd.errors
    else
      @errors = []
      query = Video.eager_load(:channel)
        .where(status: :unseen)
        .order(video_published_at: :desc)

      @pagy, @videos = pagy(query,  link_extra: 'data-turbo-frame="content" data-turbo-action="advance"')
      
      RefreshFeed.new(channel: @channel).perform
    end
  end

  def destroy
    @channel.destroy!
     Turbo::StreamsChannel.broadcast_update_to(
       :videos,
       target: 'new-video-count', 
       html: Video.where(status: :unseen).count
     )
  end

  def update
    RefreshFeed.new(channel: @channel).perform
  end

  def set_channel
    if params[:id]
      @channel = Channel.find(params[:id])
    end
  end
end
