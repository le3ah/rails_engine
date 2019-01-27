require 'rails_helper'
require 'pry'

describe "Invoice Items API" do
  it "sends a list of invoice items" do
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


    get '/api/v1/invoice_items'

    expect(response).to be_successful
    invoice_items = JSON.parse(response.body)

    expect(invoice_items.count).to eq(1)
    expect(invoice_items["data"].count).to eq(3)
  end
  context "parameter find search" do
    it "can find a single object by id" do
      merchant = create(:merchant)
      customer = create(:customer)
      item_1 = create(:item, merchant: merchant)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)

      get "/api/v1/invoice_items/find?id=#{invoice_item_1.id}"

      invoice_item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(invoice_item["data"]["id"]).to eq(invoice_item_1.id.to_s)
    end
    it "can find a single object by item_id" do
      merchant = create(:merchant)
      customer = create(:customer)
      item_1 = create(:item, merchant: merchant)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)

      get "/api/v1/invoice_items/find?item_id=#{invoice_item_1.item_id}"

      invoice_item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(invoice_item["data"]["id"]).to eq(invoice_item_1.id.to_s)
    end
    it "can find a single object by invoice_id" do
      merchant = create(:merchant)
      customer = create(:customer)
      item_1 = create(:item, merchant: merchant)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)

      get "/api/v1/invoice_items/find?invoice_id=#{invoice_item_1.invoice_id}"

      invoice_item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(invoice_item["data"]["id"]).to eq(invoice_item_1.id.to_s)
    end
    it "can find a single object by quantity" do
      merchant = create(:merchant)
      customer = create(:customer)
      item_1 = create(:item, merchant: merchant)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)

      get "/api/v1/invoice_items/find?quantity=#{invoice_item_1.quantity}"

      invoice_item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(invoice_item["data"]["id"]).to eq(invoice_item_1.id.to_s)
    end
    it "can find a single object by unit_price" do
      merchant = create(:merchant)
      customer = create(:customer)
      item_1 = create(:item, merchant: merchant)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)

      get "/api/v1/invoice_items/find?unit_price=#{invoice_item_1.unit_price}"

      invoice_item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(invoice_item["data"]["id"]).to eq(invoice_item_1.id.to_s)
    end
  end
end
