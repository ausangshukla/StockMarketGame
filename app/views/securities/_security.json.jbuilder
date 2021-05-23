json.extract! security, :id, :sec_type, :symbol, :name, :prev_closing_price, :opening_trade_price, :day_high_price, :day_low_price, :price, :market_cap, :pe, :last_trade_date, :created_at, :updated_at
json.url security_url(security, format: :json)
