require 'rails_helper'
require 'pry'

describe "Invoices API" do
  it "sends a list of invoices" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1)

    get '/api/v1/invoices'

    expect(response).to be_successful
    invoices = JSON.parse(response.body)

    expect(invoices.count).to eq(1)
    expect(invoices["data"].count).to eq(3)
  end
  context "parameter find search" do
    it "can find a single object by id" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      get "/api/v1/invoices/find?id=#{invoice_1.id}"

      invoice = JSON.parse(response.body)
      expect(response).to be_successful
      expect(invoice["data"]["id"]).to eq(invoice_1.id.to_s)
    end
    it "can find a single object by customer_id" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      get "/api/v1/invoices/find?customer_id=#{invoice_1.customer_id}"

      invoice = JSON.parse(response.body)
      expect(response).to be_successful
      expect(invoice["data"]["id"]).to eq(invoice_1.id.to_s)
    end
    it "can find a single object by merchant_id" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      get "/api/v1/invoices/find?merchant_id=#{invoice_1.merchant_id}"

      invoice = JSON.parse(response.body)
      expect(response).to be_successful
      expect(invoice["data"]["id"]).to eq(invoice_1.id.to_s)
    end
    it "can find a single object by status" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      get "/api/v1/invoices/find?status=#{invoice_1.status}"

      invoice = JSON.parse(response.body)
      expect(response).to be_successful
      expect(invoice["data"]["id"]).to eq(invoice_1.id.to_s)
    end
    it "can find a single object by created_at" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer, created_at: "2012-03-25 09:54:09 UTC")
      get "/api/v1/invoices/find?created_at=#{invoice_1.created_at}"

      invoice = JSON.parse(response.body)
      expect(response).to be_successful
      expect(invoice["data"]["id"]).to eq(invoice_1.id.to_s)
    end
    it "can find a single object by updated_at" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer, updated_at: "2012-03-25 09:54:09 UTC")
      get "/api/v1/invoices/find?updated_at=#{invoice_1.updated_at}"

      invoice = JSON.parse(response.body)
      expect(response).to be_successful
      expect(invoice["data"]["id"]).to eq(invoice_1.id.to_s)
    end
  end
end
