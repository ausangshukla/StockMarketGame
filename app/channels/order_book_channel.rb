class OrderBookChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "order_book:security_id:#{params[:security_id]}"  
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
