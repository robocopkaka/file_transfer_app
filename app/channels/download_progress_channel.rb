class DownloadProgressChannel < ApplicationCable::Channel
  def subscribed
    stream_from "download_progress_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
