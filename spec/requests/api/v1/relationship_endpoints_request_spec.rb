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
  end
end
