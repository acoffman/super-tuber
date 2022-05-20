class VideosController < ApplicationController
  before_action :ensure_logged_in
  before_action :set_channel, :set_video, :set_filter_request

  def index
    @selected = 'new'
    get_videos
  end

  def new
    @selected = 'new'
    get_videos
  end

  def watched
    @selected = 'watched'
    get_videos(status: :seen)
  end

  def saved
    @selected = 'saved'
    get_videos(status: :saved)
  end

  def update
    @video.update!(params.permit(:status))
  end

  def destroy
    @video.destroy!
  end

  private
  def set_channel
    if params[:channel_id]
      @channel = Channel.find(params[:channel_id])
    end
  end

  def set_video
    if params[:id]
      @video = Video.find(params[:id])
    end
  end

  def get_videos(status: :unseen)
    @pagy, @videos = pagy(query(status: status),  link_extra: 'data-turbo-frame="content" data-turbo-action="advance"')
    render :index
  end

  def query(status: :unseen)
    query = Video.eager_load(:channel)
      .where(status: status)
      .order(video_published_at: :desc)
    if @channel
      query = query.where(channel: @channel)
    end
    if params[:filter].present?
      query = query.where('videos.title LIKE ?', "%#{params[:filter]}%")
    end
    query
  end

  def set_filter_request
    @is_filter_request = params[:filter_request]
  end
end
