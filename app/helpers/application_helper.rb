module ApplicationHelper
  include Pagy::Frontend

  def tag_class(channel: )
    case channel.last_fetch_status
    when 'failure'
      'is-warning'
    when 'success'
      'is-info'
    else
      'is-dark'
    end
  end

  def nav_class(id:, selected:)
    if id == selected
      'level-item nav-selected is-underlined'
    else
      'level-item'
    end
  end

  def filter_path_helper(selected:, channel:)
    if selected == 'channels'
      return channels_path
    end

    if channel.nil? 
      if selected == 'watched'
        watched_videos_path
      elsif selected == 'saved'
        saved_videos_path
      else
        videos_path
      end
    else
      if selected == 'watched'
        channel_videos_watched_path(@channel)
      elsif selected == 'saved'
        channel_videos_saved_path(@channel)
      else
        channel_videos_path(@channel)
      end
    end
  end
end
