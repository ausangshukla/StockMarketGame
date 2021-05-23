json.extract! trade, :id, :order_id, :symbol, :quantity, :price, :buyer_id, :seller_id, :created_at, :updated_at
json.url trade_url(trade, format: :json)
