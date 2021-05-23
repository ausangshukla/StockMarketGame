json.extract! order, :id, :user_id, :side, :symbol, :security_id, :quantity, :price, :price_type, :order_type, :qualifier, :linked_short_cover_id, :filled_qty, :open_qty, :status, :created_at, :updated_at
json.url order_url(order, format: :json)
