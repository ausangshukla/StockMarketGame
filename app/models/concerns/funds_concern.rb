module FundsConcern
    extend ActiveSupport::Concern
  

    def blockFunds(amount)
        debitFunds(amount)
        used_margin += amount
    end

    def unblockFunds(amount)
        creditFunds(amount)
        used_margin -= amount
    end


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