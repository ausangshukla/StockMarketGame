class Security < ApplicationRecord
    validates :name, :symbol, :sec_type, :market_cap, :pe, presence: true

    SEC_TYPES = ["Equity", "Debt"]
end
