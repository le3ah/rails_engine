require 'rails_helper'
require 'pry'

describe 'Merchant relationships' do
  it "returns collection of items associated with merchant" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)

    get "/api/v1/merchants/#{merchant_1.id}/items"

    expect(response).to be_successful
    items = JSON.parse(response.body)

    expect(items["data"].count).to eq(3)
    expect(items["data"][0]["attributes"]["merchant_id"]).to eq(merchant_1.id)
  end
  it "returns a collection of invoices associated with that merchant" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_2)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_2, customer: customer_1)

    get "/api/v1/merchants/#{merchant_1.id}/invoices"
    expect(response).to be_successful
    invoices = JSON.parse(response.body)

    expect(invoices["data"].count).to eq(2)
    expect(invoices["data"][0]["attributes"]["merchant_id"]).to eq(merchant_1.id)
  end
end
describe 'Invoice Relationships' do
  it "returns a colelction of associated transactions" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_2)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_2, customer: customer_1)
    transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")
    transaction_2 = create(:transaction, invoice_id: invoice_1.id, result: "failed", updated_at: "012-03-25 14:54:09 UTC")
    transaction_3 = create(:transaction, invoice_id: invoice_2.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

    get "/api/v1/invoices/#{invoice_1.id}/transactions"

    expect(response).to be_successful
    transactions = JSON.parse(response.body)

    expect(transactions["data"].count).to eq(2)
    expect(transactions["data"][0]["attributes"]["invoice_id"]).to eq(invoice_1.id)
  end
end
