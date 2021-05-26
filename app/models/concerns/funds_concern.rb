module FundsConcern
    extend ActiveSupport::Concern
  

    def debitFunds(amount)
        available_margin -= amount
        available_cash -= amount
    end

    def creditFunds(amount)
        available_margin += amount
        available_cash += amount
    end

    def canDebit?(amount)
        available_margin > amount
    end

end