require 'rails_helper'
require 'pry'

describe "Merchants API" do
  it "sends a lits of merchants" do
    create_list(:merchant, 3)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants.count).to eq(1)
    expect(merchants["data"].count).to eq(3)

  end
  it "can get one merchant by its id" do
    id = create(:merchant).id.to_s

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(id)
  end
  context "parameter find search" do
    it "can find a single object by id" do
      id = create(:merchant).id.to_s

      get "/api/v1/merchants/find?id=#{id}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"]["id"]).to eq(id)
    end
    it "can find a single object by name" do
      name = create(:merchant).name

      get "/api/v1/merchants/find?name=#{name}"
      merchant = JSON.parse(response.body)
      expect(response).to be_successful

      expect(merchant["data"]["attributes"]["name"]).to eq(name)
    end
    it "can find by name case insensitive" do
      merchant_1 = create(:merchant, name: "Jim")

      get "/api/v1/merchants/find?name=#{merchant_1.name.upcase}"
      merchant = JSON.parse(response.body)
      expect(response).to be_successful

      expect(merchant["data"]["attributes"]["name"]).to eq(merchant_1.name)

    end
    it "can find by created_at date" do
      merchant_1 = create(:merchant, created_at: "2012-03-27 14:53:59 UTC")

      get "/api/v1/merchants/find?created_at=#{merchant_1.created_at}"
      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["id"]).to eq(merchant_1.id)
    end
    it "can find by updated_at date" do
      merchant_1 = create(:merchant, updated_at: "2012-03-27 14:53:59 UTC")

      get "/api/v1/merchants/find?updated_at=#{merchant_1.updated_at}"
      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["id"]).to eq(merchant_1.id)
    end
  end
  context "parameter find all search" do
    it "can find all matches based on id" do
      id = create(:merchant).id

      get "/api/v1/merchants/find_all?id=#{id}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"][0]["attributes"]["id"]).to eq(id)
    end
    it "can find all matches based on name" do
      customer_1 = create(:merchant, name: "George")
      customer_2 = create(:merchant, name: "George")
      customer_3 = create(:merchant, name: "George")
      customer_4 = create(:merchant, name: "Sam")

      get "/api/v1/merchants/find_all?name=#{customer_1.name}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"][0]["attributes"]["name"]).to eq(customer_1.name)
      expect(merchant["data"][1]["attributes"]["name"]).to eq(customer_1.name)
      expect(merchant["data"][-1]["attributes"]["name"]).to eq(customer_1.name)
      expect(merchant["data"].count).to eq(3)
    end
  end
  it "returns a random resource" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/random"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful

    expect(merchant.count).to eq(1)
    expect(merchant["data"]["type"]).to eq("merchant")
  end
  context "All merchants business intelligence" do
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
    it "returns the top x merchants ranked by total revenue" do

      x = 3
      get "/api/v1/merchants/most_revenue?quantity=#{x}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"].count).to eq(x)
      expect(merchant["data"][0]["type"]).to eq("merchant")
      expect(merchant["data"][0]["attributes"]["name"]).to eq(@merchant_4.name)
    end
    it "returns the top x merchants ranked by total number of items sold" do

      x = 4
      get "/api/v1/merchants/most_items?quantity=#{x}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"].count).to eq(x)
      expect(merchant["data"][0]["attributes"]["name"]).to eq(@merchant_4.name)
    end

    it "returns the total revenue for date x across all merchants" do

      x = @transaction_1.updated_at

      get "/api/v1/merchants/revenue?date=#{x}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["total_revenue"]).to eq(650)
    end
  end
  context 'Single Merchant business intelligence' do
    before :each do
      @merchant = create(:merchant)
      @merchant_10 = create(:merchant)
      @customer = create(:customer, first_name: "Lucille")
      @customer_10 = create(:customer)

      @item_1 = create(:item, merchant: @merchant_10)
      @item_2 = create(:item, merchant: @merchant)
      @item_3 = create(:item, merchant: @merchant)
      @item_4 = create(:item, merchant: @merchant)
      @item_5 = create(:item, merchant: @merchant)

      @invoice_1 = create(:invoice, merchant: @merchant_10, customer: @customer, updated_at: "012-03-27 14:54:09 UTC")
      @invoice_2 = create(:invoice, merchant: @merchant, customer: @customer, updated_at: "012-03-27 14:54:09 UTC")
      @invoice_3 = create(:invoice, merchant: @merchant, customer: @customer, updated_at: "012-03-27 14:54:09 UTC")
      @invoice_4 = create(:invoice, merchant: @merchant, customer: @customer, updated_at: "012-03-17 14:54:09 UTC")
      @invoice_5 = create(:invoice, merchant: @merchant, customer: @customer_10, updated_at: "012-03-17 14:54:09 UTC")

      @invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: @item_1.id, invoice_id: @invoice_1.id)
      @invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: @item_2.id, invoice_id: @invoice_2.id)
      @invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: @item_3.id, invoice_id: @invoice_3.id)
      @invoice_item_4 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: @item_4.id, invoice_id: @invoice_4.id)
      @invoice_item_5 = create(:invoice_item, quantity: 4, unit_price: 1, item_id: @item_5.id, invoice_id: @invoice_5.id)

      @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")
      @transaction_2 = create(:transaction, invoice_id: @invoice_2.id, result: "success", updated_at: "012-03-25 14:54:09 UTC")
      @transaction_3 = create(:transaction, invoice_id: @invoice_3.id, result: "failed", updated_at: "012-03-27 14:54:09 UTC")
      @transaction_4 = create(:transaction, invoice_id: @invoice_4.id, result: "success", updated_at: "012-03-17 14:54:09 UTC")
      @transaction_5 = create(:transaction, invoice_id: @invoice_5.id, result: "success", updated_at: "012-02-17 14:54:09 UTC")
    end
    it "returns the revenue for a single merchant across successful transactions" do

      get "/api/v1/merchants/#{@merchant.id}/revenue"
      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["total_revenue"]).to eq(4204)
    end
    it "returns the total revenue for that merchant for invoice date x" do
      x = @invoice_2.updated_at

      get "/api/v1/merchants/#{@merchant.id}/revenue?date=#{x}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful

      expect(merchant["data"]["attributes"]["total_revenue"]).to eq(200)
    end
    it "returns the customer who conducted the most successful transactions" do

      get "/api/v1/merchants/#{@merchant.id}/favorite_customer"
      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"]["attributes"]["first_name"]).to eq("Lucille")
      expect(merchant["data"]["attributes"]["first_name"]).to_not eq("Gob")
    end
  end
end
