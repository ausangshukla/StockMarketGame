class PositionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "position:user_id:#{params[:user_id]}"  
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
