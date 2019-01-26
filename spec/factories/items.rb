FactoryBot.define do
  factory :item do
    name { "MyItem" }
    description { "ItemText" }
    unit_price { 1 }
    merchant { nil }
  end
end
