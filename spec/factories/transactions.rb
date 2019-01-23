FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { "" }
    credit_card_expiration_date { "2019-01-23" }
    result { "TransactionResult" }
  end
end
