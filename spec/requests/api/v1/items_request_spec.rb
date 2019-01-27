require 'rails_helper'
require 'pry'

describe "Items API" do
  it "sends a list of items" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)
    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body)

    expect(items.count).to eq(1)
    expect(items["data"].count).to eq(3)
  end
  context "parameter find search" do
    it "can find a single object by id" do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      get "/api/v1/items/find?id=#{item_1.id}"

      item = JSON.parse(response.body)
      expect(response).to be_successful
      expect(item["data"]["id"]).to eq(item_1.id.to_s)
    end
    it "can find a single object by name" do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      get "/api/v1/items/find?name=#{item_1.name}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"]["attributes"]["name"]).to eq(item_1.name)
    end
    it "can find a single object by description" do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      get "/api/v1/items/find?description=#{item_1.description}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"]["attributes"]["description"]).to eq(item_1.description)
    end
    it "can find a single object by unit_price" do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      get "/api/v1/items/find?unit_price=#{item_1.unit_price}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"]["attributes"]["unit_price"]).to eq(item_1.unit_price)
    end
    it "can find a single object by merchant_id" do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      get "/api/v1/items/find?merchant_id=#{item_1.merchant_id}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"]["attributes"]["merchant_id"]).to eq(item_1.merchant_id)
    end
    it "can find a single object by created_at" do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant, created_at: "2012-03-27 14:53:59 UTC")
      get "/api/v1/items/find?created_at=#{item_1.created_at}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"]["attributes"]["id"]).to eq(item_1.id)
    end
    it "can find a single object by updated_at" do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant, updated_at: "2012-03-27 14:53:59 UTC")
      get "/api/v1/items/find?updated_at=#{item_1.updated_at}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"]["attributes"]["id"]).to eq(item_1.id)
    end
  end
  context "parameter find all search" do
    it "can find all matches based on id" do
      merchant_1 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)

      get "/api/v1/items/find_all?id=#{item_1.id}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"][0]["attributes"]["id"]).to eq(item_1.id)
    end
    it "can find all matches based on name" do
      merchant_1 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)

      get "/api/v1/items/find_all?name=#{item_1.name}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"][0]["attributes"]["id"]).to eq(item_1.id)
    end
    it "can find all matches based on description" do
      merchant_1 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)

      get "/api/v1/items/find_all?description=#{item_1.description}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"][0]["attributes"]["id"]).to eq(item_1.id)
    end
    it "can find all matches based on unit_price" do
      merchant_1 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)

      get "/api/v1/items/find_all?unit_price=#{item_1.unit_price}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"][0]["attributes"]["id"]).to eq(item_1.id)
    end
    it "can find all matches based on merchant_id" do
      merchant_1 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)

      get "/api/v1/items/find_all?merchant_id=#{item_1.merchant_id}"

      item = JSON.parse(response.body)
      expect(response).to be_successful

      expect(item["data"][0]["attributes"]["id"]).to eq(item_1.id)
    end
  end
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

      @invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer_1, updated_at: "2012-03-27 14:54:09 UTC")
      @invoice_2 = create(:invoice, merchant: @merchant_2, customer: @customer_1, updated_at: "2012-03-27 14:54:09 UTC")
      @invoice_3 = create(:invoice, merchant: @merchant_3, customer: @customer_1, updated_at: "2012-03-17 14:54:09 UTC")
      @invoice_4 = create(:invoice, merchant: @merchant_4, customer: @customer_1, updated_at: "2012-03-27 14:54:09 UTC")
      @invoice_5 = create(:invoice, merchant: @merchant_5, customer: @customer_1, updated_at: "2012-03-27 14:54:09 UTC")
      @invoice_6 = create(:invoice, merchant: @merchant_5, customer: @customer_1, updated_at: "2012-03-17 14:54:09 UTC")
      @invoice_7 = create(:invoice, merchant: @merchant_5, customer: @customer_1, updated_at: "2012-03-17 14:54:09 UTC")
      @invoice_8 = create(:invoice, merchant: @merchant_1, customer: @customer_1, updated_at: "2012-03-27 14:54:09 UTC")

      @invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: @item_1.id, invoice_id: @invoice_1.id)
      @invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: @item_2.id, invoice_id: @invoice_2.id)
      @invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: @item_3.id, invoice_id: @invoice_3.id)
      @invoice_item_4 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: @item_4.id, invoice_id: @invoice_4.id)
      @invoice_item_5 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: @item_4.id, invoice_id: @invoice_5.id)
      @invoice_item_6 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: @item_4.id, invoice_id: @invoice_6.id)
      @invoice_item_7 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: @item_4.id, invoice_id: @invoice_7.id)
      @invoice_item_8 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: @item_1.id, invoice_id: @invoice_8.id)

      @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: "success", updated_at: "2012-03-27 14:54:09 UTC")
      @transaction_2 = create(:transaction, invoice_id: @invoice_2.id, result: "success", updated_at: "2012-03-25 14:54:09 UTC")
      @transaction_3 = create(:transaction, invoice_id: @invoice_3.id, result: "success", updated_at: "2012-03-27 14:54:09 UTC")
      @transaction_4 = create(:transaction, invoice_id: @invoice_4.id, result: "success", updated_at: "2012-03-17 14:54:09 UTC")

    end
    it "returns the top x items ranked by total revenue generated" do
      x = 3

      get "/api/v1/items/most_revenue?quantity=#{x}"

      item = JSON.parse(response.body)
      expect(response).to be_successful
      expect(item["data"].count).to eq(x)
      expect(item["data"][0]["type"]).to eq("item")
      expect(item["data"][0]["attributes"]["name"]).to eq(@item_4.name)
    end

    it "returns the top x item instances ranked by total number sold" do
      x = 3

      get "/api/v1/items/most_items?quantity=#{x}"

      item = JSON.parse(response.body)
      expect(response).to be_successful
      expect(item["data"].count).to eq(x)
      expect(item["data"][0]["type"]).to eq("item")
    end
    it "returns the date with the most sales for the given item by invoice date" do
      get "/api/v1/items/#{@item_1.id}/best_day"

      date = "2012-03-27 14:54:09 UTC"
      item = JSON.parse(response.body)
      expect(response).to be_successful
      expect(item["data"]["type"]).to eq("best_day_item")
      expect(item["data"]["attributes"]["updated_at"][0..9]).to eq(date[0..9])

    end
  end
end
