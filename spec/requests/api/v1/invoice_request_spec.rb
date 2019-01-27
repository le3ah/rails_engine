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
end
