require 'rails_helper'
require 'pry'

describe "Transactions API" do
  it "sends a list of transactions" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_2.id, invoice_id: invoice_2.id)
    invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_3.id)

    transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")
    transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: "success", updated_at: "012-03-25 14:54:09 UTC")
    transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

    get '/api/v1/transactions'

    expect(response).to be_successful
    transactions = JSON.parse(response.body)

    expect(transactions.count).to eq(1)
    expect(transactions["data"].count).to eq(3)
  end
end
