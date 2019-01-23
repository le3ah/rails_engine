FactoryBot.define do
  factory :invoice do
    customer { nil }
    merchant { nil }
    status { "StatusString" }
  end
end
