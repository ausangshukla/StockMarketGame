json.extract! position, :id, :name, :user_id, :security_id, :symbol, :quantity, :average_cost, :current_value, :eod_value, :created_at, :updated_at
json.url position_url(position, format: :json)
