FactoryBot.define do
  factory :statement do
    particulars { "MyText" }
    debit { 1.5 }
    credit { 1.5 }
    net { 1.5 }
    stmt_type { "MyString" }
    user_id { 1 }
    ref_id { 1 }
    ref_type { "MyString" }
  end
end
