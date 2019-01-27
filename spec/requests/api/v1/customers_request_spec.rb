require 'rails_helper'
require 'pry'

describe "Customers API" do
  it "sends a lits of customers" do
    create_list(:customer, 3)
    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers.count).to eq(1)
    expect(customers["data"].count).to eq(3)

  end
  it "can get one customer by its id" do
    id = create(:customer).id.to_s

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(id)
  end
  context "parameter find search" do
    it "can find a single object by id" do
      id = create(:customer).id.to_s

      get "/api/v1/customers/find?id=#{id}"

      customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(customer["data"]["id"]).to eq(id)
    end
    it "can find a single object by first name" do
      first_name = create(:customer).first_name

      get "/api/v1/customers/find?first_name=#{first_name}"
      customer = JSON.parse(response.body)
      expect(response).to be_successful

      expect(customer["data"][0]["attributes"]["first_name"]).to eq(first_name)
    end
    it "can find a single object by first name case_insensitive" do
      first_name = create(:customer, first_name: "Kathy").first_name

      get "/api/v1/customers/find?first_name=#{first_name.upcase}"
      customer = JSON.parse(response.body)
      expect(response).to be_successful

      expect(customer["data"][0]["attributes"]["first_name"]).to eq(first_name)
    end
    it "can find a single object by last name" do
      last_name = create(:customer).last_name

      get "/api/v1/customers/find?last_name=#{last_name}"
      customer = JSON.parse(response.body)
      expect(response).to be_successful

      expect(customer["data"][0]["attributes"]["last_name"]).to eq(last_name)
    end
    it "can find a single object by last name case case_insensitive" do
      last_name = create(:customer).last_name

      get "/api/v1/customers/find?last_name=#{last_name.upcase}"
      customer = JSON.parse(response.body)
      expect(response).to be_successful

      expect(customer["data"][0]["attributes"]["last_name"]).to eq(last_name)
    end
  end
  context "parameter find all search" do
    it "can find all matches based on id" do
      id = create(:customer).id

      get "/api/v1/customers/find_all?id=#{id}"

      customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(customer["data"][0]["attributes"]["id"]).to eq(id)
    end
    it "can find all matches based on first_name" do
      customer_1 = create(:customer, first_name: "George")
      customer_2 = create(:customer, first_name: "George")
      customer_3 = create(:customer, first_name: "George")
      customer_4 = create(:customer, first_name: "Sam")

      get "/api/v1/customers/find_all?first_name=#{customer_1.first_name}"

      customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(customer["data"][0]["attributes"]["first_name"]).to eq(customer_1.first_name)
      expect(customer["data"][1]["attributes"]["first_name"]).to eq(customer_1.first_name)
      expect(customer["data"][-1]["attributes"]["first_name"]).to eq(customer_1.first_name)
      expect(customer["data"].count).to eq(3)
    end
    it "can find all matches based on last_name" do
      customer_1 = create(:customer, last_name: "George")
      customer_2 = create(:customer, last_name: "George")
      customer_3 = create(:customer, last_name: "George")
      customer_4 = create(:customer, last_name: "Sam")

      get "/api/v1/customers/find_all?last_name=#{customer_1.last_name}"

      customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(customer["data"][0]["attributes"]["last_name"]).to eq(customer_1.last_name)
      expect(customer["data"][1]["attributes"]["last_name"]).to eq(customer_1.last_name)
      expect(customer["data"][-1]["attributes"]["last_name"]).to eq(customer_1.last_name)
      expect(customer["data"].count).to eq(3)
    end
  end
  it "returns a random resource" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)

    get "/api/v1/customers/random"

    customer = JSON.parse(response.body)
    expect(response).to be_successful

    expect(customer.count).to eq(1)
    expect(customer["data"]["type"]).to eq("customer")
  end
  it "returns a merchant where the customer has conducted the most successful transactions" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)
  
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_2, customer: customer_1)
    transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")
    transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: "success", updated_at: "012-03-25 14:54:09 UTC")
    transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

    get "/api/v1/customers/#{customer_1.id}/favorite_merchant"

    customers = JSON.parse(response.body)
    expect(response).to be_successful

    expect(customers["data"]["type"]).to eq("favorite_merchant")
    expect(customers["data"]["attributes"]["name"]).to eq(merchant_2.name)
  end
end
