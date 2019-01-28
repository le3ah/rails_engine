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
  it "displays one transaction" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

    get "/api/v1/transactions/#{transaction_1.id}"
    expect(response).to be_successful
    transactions = JSON.parse(response.body)

    expect(transactions["data"]["id"]).to eq(transaction_1.id.to_s)
  end
  context "parameter find search" do
    it "can find a single object by id" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find?id=#{transaction_1.id}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"]["id"]).to eq(transaction_1.id.to_s)
    end
    it "can find a single object by invoice_id" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find?invoice_id=#{transaction_1.invoice_id}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"]["id"]).to eq(transaction_1.id.to_s)
    end
    it "can find a single object by credit_card_number" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find?credit_card_number=#{transaction_1.credit_card_number}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"]["id"]).to eq(transaction_1.id.to_s)
    end
    it "can find a single object by credit_card_expiration_date" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find?credit_card_expiration_date=#{transaction_1.credit_card_expiration_date}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"]["id"]).to eq(transaction_1.id.to_s)
    end
    it "can find a single object by result" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find?result=#{transaction_1.result}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"]["id"]).to eq(transaction_1.id.to_s)
    end
    it "can find a single object by created_at" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", created_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find?created_at=#{transaction_1.created_at}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"]["id"]).to eq(transaction_1.id.to_s)
    end
    it "can find a single object by updated_at" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find?updated_at=#{transaction_1.updated_at}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"]["id"]).to eq(transaction_1.id.to_s)
    end
  end
  context "parameter find all search" do
    it "can find all matches based on id" do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find_all?id=#{transaction_1.id}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"][0]["attributes"]["id"]).to eq(transaction_1.id)
    end
    it "can find all matches based on invoice_id" do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find_all?invoice_id=#{transaction_1.invoice_id}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"][0]["attributes"]["id"]).to eq(transaction_1.id)
    end
    it "can find all matches based on credit_card_number" do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find_all?credit_card_number=#{transaction_1.credit_card_number}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"][0]["attributes"]["id"]).to eq(transaction_1.id)
    end
    it "can find all matches based on credit_card_expiration_date" do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find_all?credit_card_expiration_date=#{transaction_1.credit_card_expiration_date}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"][0]["attributes"]["id"]).to eq(transaction_1.id)
    end
    it "can find all matches based on result" do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find_all?result=#{transaction_1.result}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"][0]["attributes"]["id"]).to eq(transaction_1.id)
    end
    it "can find all matches based on created_at" do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", created_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find_all?created_at=#{transaction_1.created_at}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"][0]["attributes"]["id"]).to eq(transaction_1.id)
    end
    it "can find all matches based on updated_at" do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")

      get "/api/v1/transactions/find_all?updated_at=#{transaction_1.updated_at}"

      transaction = JSON.parse(response.body)
      expect(response).to be_successful

      expect(transaction["data"][0]["attributes"]["id"]).to eq(transaction_1.id)
    end
  end
end
