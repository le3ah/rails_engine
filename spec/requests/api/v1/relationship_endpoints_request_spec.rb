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
    expect(items["data"][0]["type"]).to eq("associated_item")
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
    expect(invoices["data"][0]["type"]).to eq("associated_invoice")
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
    expect(transactions["data"][0]["type"]).to eq("associated_transaction")
  end
  it "returns a collection of associated invoice_items" do
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

    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_2.id, invoice_id: invoice_2.id)
    invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_1.id)

    get "/api/v1/invoices/#{invoice_1.id}/invoice_items"

    expect(response).to be_successful
    invoice_items = JSON.parse(response.body)

    expect(invoice_items["data"].count).to eq(2)
    expect(invoice_items["data"][0]["type"]).to eq("associated_invoice_item")
  end
  it "returns a collection of associated items" do
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

    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_2.id, invoice_id: invoice_1.id)
    invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_2.id)

    get "/api/v1/invoices/#{invoice_1.id}/items"

    expect(response).to be_successful
    items = JSON.parse(response.body)

    expect(items["data"].count).to eq(2)
    expect(items["data"][0]["type"]).to eq("associated_item")
    expect(items["data"][-1]["type"]).to eq("associated_item")
  end
  it "returns the associated customer" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    merchant_1 = create(:merchant)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    get "/api/v1/invoices/#{invoice_1.id}/customer"

    expect(response).to be_successful

    invoices = JSON.parse(response.body)
    expect(invoices["data"]["id"]).to eq(customer_1.id.to_s)
    expect(invoices["data"]["id"]).to_not eq(customer_2.id.to_s)
    expect(invoices["data"]["type"]).to eq("associated_customer")
  end
  it "returns the associated merchant" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    get "/api/v1/invoices/#{invoice_1.id}/merchant"

    expect(response).to be_successful
    invoices = JSON.parse(response.body)

    expect(invoices["data"]["id"]).to eq(merchant_1.id.to_s)
    expect(invoices["data"]["id"]).to_not eq(merchant_2.id.to_s)
    expect(invoices["data"]["type"]).to eq("associated_merchant")
  end
end
describe 'Invoice Items relationships' do
  it "returns the associated invoice" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)

    get "/api/v1/invoice_items/#{invoice_item_1.id}/invoice"

    expect(response).to be_successful
    invoice = JSON.parse(response.body)

    expect(invoice["data"]["id"]).to eq(invoice_1.id.to_s)
    expect(invoice["data"]["id"]).to_not eq(invoice_2.id.to_s)
    expect(invoice["data"]["type"]).to eq("associated_invoice")
  end
  it "returns the associated item" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)

    get "/api/v1/invoice_items/#{invoice_item_1.id}/item"

    expect(response).to be_successful
    item = JSON.parse(response.body)

    expect(item["data"]["id"]).to eq(item_1.id.to_s)
    expect(item["data"]["id"]).to_not eq(item_2.id.to_s)
    expect(item["data"]["type"]).to eq("associated_item")
  end
end
describe 'Items relationships' do
  it "returns a collection of associated invoice items" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_2)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_2.id)

    get "/api/v1/items/#{item_1.id}/invoice_items"

    expect(response).to be_successful
    invoice_items = JSON.parse(response.body)

    expect(invoice_items["data"][0]["id"]).to eq(invoice_item_1.id.to_s)
    expect(invoice_items["data"][1]["id"]).to eq(invoice_item_2.id.to_s)
    expect(invoice_items["data"][0]["id"]).to_not eq(invoice_item_3.id.to_s)
    expect(invoice_items["data"][1]["id"]).to_not eq(invoice_item_3.id.to_s)
    expect(invoice_items["data"].count).to eq(2)
    expect(invoice_items["data"][0]["type"]).to eq("associated_invoice_item")
  end
  it "returns a the associated merchant" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_2)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_2, customer: customer_1)

    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_2.id)

    get "/api/v1/items/#{item_1.id}/merchant"

    expect(response).to be_successful
    item = JSON.parse(response.body)

    expect(item["data"]["id"]).to eq(merchant_1.id.to_s)
    expect(item["data"]["type"]).to eq("associated_merchant")
  end
end
describe 'Transactions relationships' do
  it "returns a the associated invoice" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_2)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_2, customer: customer_1)

    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_2.id)
    transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

    get "/api/v1/transactions/#{transaction_1.id}/invoice"

    expect(response).to be_successful
    transaction = JSON.parse(response.body)

    expect(transaction["data"]["id"]).to eq(invoice_1.id.to_s)
    expect(transaction["data"]["type"]).to eq("associated_invoice")
  end
end
describe 'Customer relationships' do
  it "returns a collection of associated invoices" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_2)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_2, customer: customer_1)

    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_2.id)

    get "/api/v1/customers/#{customer_1.id}/invoices"

    expect(response).to be_successful
    customer = JSON.parse(response.body)

    expect(customer["data"][0]["id"]).to eq(invoice_1.id.to_s)
    expect(customer["data"].count).to eq(3)
    expect(customer["data"][0]["type"]).to eq("associated_invoice")
  end
  it "returns a collection of associated invoices" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_2)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_2, customer: customer_1)

    invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_1.id, invoice_id: invoice_1.id)
    invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_2.id)
    transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")
    transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

    get "/api/v1/customers/#{customer_1.id}/transactions"

    expect(response).to be_successful
    customer = JSON.parse(response.body)

    expect(customer["data"][0]["id"]).to eq(transaction_1.id.to_s)
    expect(customer["data"].count).to eq(2)
    expect(customer["data"][0]["type"]).to eq("associated_transaction")
  end
end
