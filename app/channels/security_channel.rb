class SecurityChannel < ApplicationCable::Channel
  def subscribed
    stream_from "security"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
