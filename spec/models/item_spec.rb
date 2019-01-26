require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'class methods' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)
      @merchant_4 = create(:merchant)
      @merchant_5 = create(:merchant)

      customer_1 = create(:customer)

      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_2)
      @item_3 = create(:item, merchant: @merchant_3)
      @item_4 = create(:item, merchant: @merchant_4)
      @item_5 = create(:item, merchant: @merchant_5)

      invoice_1 = create(:invoice, merchant: @merchant_1, customer: customer_1)
      invoice_2 = create(:invoice, merchant: @merchant_2, customer: customer_1)
      invoice_3 = create(:invoice, merchant: @merchant_3, customer: customer_1)
      invoice_4 = create(:invoice, merchant: @merchant_4, customer: customer_1)
      invoice_5 = create(:invoice, merchant: @merchant_5, customer: customer_1)

      invoice_item_1 = create(:invoice_item, quantity: 4, unit_price: 500, item_id: @item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = create(:invoice_item, quantity: 3, unit_price: 100, item_id: @item_2.id, invoice_id: invoice_2.id)
      invoice_item_3 = create(:invoice_item, quantity: 2, unit_price: 200, item_id: @item_3.id, invoice_id: invoice_3.id)
      invoice_item_4 = create(:invoice_item, quantity: 1, unit_price: 1000, item_id: @item_4.id, invoice_id: invoice_4.id)

      @transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "2012-03-27 14:54:09 UTC")
      @transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: "success", updated_at: "2012-03-25 14:54:09 UTC")
      @transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: "success", updated_at: "2012-03-27 14:54:09 UTC")
      @transaction_4 = create(:transaction, invoice_id: invoice_4.id, result: "success", updated_at: "2012-03-17 14:54:09 UTC")
    end
    it ".most_revenue" do
      x = 3
      expect(Item.most_revenue(x)[0]).to eq(@item_1)
      expect(Item.most_revenue(x)[1]).to eq(@item_4)
      expect(Item.most_revenue(x)[-1]).to eq(@item_3)
    end
    it ".most_quantity_sold" do
      x = 3
      expect(Item.most_quantity_sold(x)[0]).to eq(@item_1)
      expect(Item.most_quantity_sold(x)[1]).to eq(@item_2)
      expect(Item.most_quantity_sold(x)[-1]).to eq(@item_3)
    end
  end
  describe 'instance methods' do
    it "#best_day" do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      customer_1 = create(:customer)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "012-03-27 14:54:09 UTC")
      invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "012-03-27 14:54:09 UTC")
      invoice_3 = create(:invoice, merchant: merchant_2, customer: customer_1, updated_at: "012-03-27 14:54:09 UTC")
      invoice_4 = create(:invoice, merchant: merchant_2, customer: customer_1, updated_at: "012-03-27 14:54:09 UTC")
      invoice_5 = create(:invoice, merchant: merchant_2, customer: customer_1, updated_at: "012-03-17 14:54:09 UTC")
      invoice_6 = create(:invoice, merchant: merchant_2, customer: customer_1, updated_at: "012-03-17 14:54:09 UTC")

      invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_1.id, invoice_id: invoice_2.id)
      invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_2.id, invoice_id: invoice_3.id)
      invoice_item_4 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: item_2.id, invoice_id: invoice_4.id)
      invoice_item_5 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: item_2.id, invoice_id: invoice_5.id)
      invoice_item_6 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: item_2.id, invoice_id: invoice_6.id)

      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")
      transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: "success", updated_at: "012-03-25 14:54:09 UTC")
      transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: "success", updated_at: "012-03-27 14:54:09 UTC")
      transaction_4 = create(:transaction, invoice_id: invoice_4.id, result: "success", updated_at: "012-03-17 14:54:09 UTC")
      transaction_5 = create(:transaction, invoice_id: invoice_4.id, result: "success", updated_at: "012-03-17 14:54:09 UTC")
      transaction_6 = create(:transaction, invoice_id: invoice_4.id, result: "success", updated_at: "012-03-17 14:54:09 UTC")

      expect(item_1.best_day.updated_at).to eq("012-03-27 14:54:09 UTC")
    end
  end
end
