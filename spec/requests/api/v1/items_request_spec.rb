require 'rails_helper'
require 'pry'

describe "Items API" do
  context "All Items Business Intelligence" do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)
      @merchant_4 = create(:merchant)
      @merchant_5 = create(:merchant)
      @customer_1 = create(:customer)

      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_2)
      @item_3 = create(:item, merchant: @merchant_3)
      @item_4 = create(:item, merchant: @merchant_4)
      @item_5 = create(:item, merchant: @merchant_5)

      @invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer_1)
      @invoice_2 = create(:invoice, merchant: @merchant_2, customer: @customer_1)
      @invoice_3 = create(:invoice, merchant: @merchant_3, customer: @customer_1)
      @invoice_4 = create(:invoice, merchant: @merchant_4, customer: @customer_1)
      @invoice_5 = create(:invoice, merchant: @merchant_5, customer: @customer_1)

      @invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: @item_1.id, invoice_id: @invoice_1.id)
      @invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: @item_2.id, invoice_id: @invoice_2.id)
      @invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: @item_3.id, invoice_id: @invoice_3.id)
      @invoice_item_4 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: @item_4.id, invoice_id: @invoice_4.id)

      @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")
      @transaction_2 = create(:transaction, invoice_id: @invoice_2.id, result: "success", updated_at: "012-03-25 14:54:09 UTC")
      @transaction_3 = create(:transaction, invoice_id: @invoice_3.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")
      @transaction_4 = create(:transaction, invoice_id: @invoice_4.id, result: "success", updated_at: "012-03-17 14:54:09 UTC")

    end
    it "returns the top x items ranked by total revenue generated" do
      x = 3

      get "/api/v1/items/most_revenue?quantity=#{x}"

      item = JSON.parse(response.body)
      expect(response).to be_successful
      expect(item["data"].count).to eq(x)
      expect(item["data"][0]["type"]).to eq("item")
    end
  end
end
