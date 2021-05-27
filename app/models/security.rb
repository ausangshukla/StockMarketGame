class Security < ApplicationRecord
    validates :name, :symbol, :sec_type, :market_cap, :pe, presence: true

    SEC_TYPES = ["Equity", "Debt"]

    after_save do
        ActionCable.server.broadcast(
            "security",
            {
                id: id,
                symbol: symbol,
                price: price
            }
          )
    end
end
