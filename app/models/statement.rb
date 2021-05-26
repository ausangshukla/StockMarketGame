class Statement < ApplicationRecord
    after_create :update_user_funds

    def update_user_funds
        if debit > 0
            self.user.debitFunds(debit)
        elsif credit > 0
            self.user.creditFunds(credit)
        else
        end
    end
end
