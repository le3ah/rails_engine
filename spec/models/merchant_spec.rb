require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:customers).through(:invoices) }


  end

  describe  'class methods' do
    it ".most_revenue" do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)
      merchant_4 = create(:merchant)
      merchant_5 = create(:merchant)

      customer_1 = create(:customer)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)
      item_3 = create(:item, merchant: merchant_3)
      item_4 = create(:item, merchant: merchant_4)
      item_5 = create(:item, merchant: merchant_5)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_1)
      invoice_3 = create(:invoice, merchant: merchant_3, customer: customer_1)
      invoice_4 = create(:invoice, merchant: merchant_4, customer: customer_1)
      invoice_5 = create(:invoice, merchant: merchant_5, customer: customer_1)

      invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_2.id, invoice_id: invoice_2.id)
      invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_3.id)
      invoice_item_4 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: item_4.id, invoice_id: invoice_4.id)

      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success")
      transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: "success")
      transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: "success")
      transaction_4 = create(:transaction, invoice_id: invoice_4.id, result: "success")

      x = 3
      expect(Merchant.most_revenue(x)[0]).to eq(merchant_4)
      expect(Merchant.most_revenue(x)[1]).to eq(merchant_3)
      expect(Merchant.most_revenue(x)[-1]).to eq(merchant_2)
    end
  end
end
