require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:customers).through(:invoices) }
  end

  describe  'class methods' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)
      @merchant_4 = create(:merchant)
      @merchant_5 = create(:merchant)

      customer_1 = create(:customer)

      item_1 = create(:item, merchant: @merchant_1)
      item_2 = create(:item, merchant: @merchant_2)
      item_3 = create(:item, merchant: @merchant_3)
      item_4 = create(:item, merchant: @merchant_4)
      item_5 = create(:item, merchant: @merchant_5)

      invoice_1 = create(:invoice, merchant: @merchant_1, customer: customer_1)
      invoice_2 = create(:invoice, merchant: @merchant_2, customer: customer_1)
      invoice_3 = create(:invoice, merchant: @merchant_3, customer: customer_1)
      invoice_4 = create(:invoice, merchant: @merchant_4, customer: customer_1)
      invoice_5 = create(:invoice, merchant: @merchant_5, customer: customer_1)

      invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: item_2.id, invoice_id: invoice_2.id)
      invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: item_3.id, invoice_id: invoice_3.id)
      invoice_item_4 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: item_4.id, invoice_id: invoice_4.id)

      @transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success", updated_at: "2012-03-27 14:54:09 UTC")
      @transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: "success", updated_at: "2012-03-25 14:54:09 UTC")
      @transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: "success", updated_at: "2012-03-27 14:54:09 UTC")
      @transaction_4 = create(:transaction, invoice_id: invoice_4.id, result: "success", updated_at: "2012-03-17 14:54:09 UTC")
    end
    it ".most_revenue" do
      x = 3
      expect(Merchant.most_revenue(x)[0]).to eq(@merchant_4)
      expect(Merchant.most_revenue(x)[1]).to eq(@merchant_3)
      expect(Merchant.most_revenue(x)[-1]).to eq(@merchant_2)
    end
    it ".most_items" do
      x = 3
      expect(Merchant.most_items(x)[0]).to eq(@merchant_4)
      expect(Merchant.most_items(x)[1]).to eq(@merchant_3)
      expect(Merchant.most_items(x)[-1]).to eq(@merchant_2)
    end
    it ".revenue_date" do
      x = @transaction_1.updated_at

      expect(Merchant.revenue_date(x).total_revenue).to eq(650)
    end
  end
  describe  'instance methods' do
    before :each do
      @merchant = create(:merchant)
      @merchant_10 = create(:merchant)
      @customer = create(:customer)
      @customer_10 = create(:customer)

      @item_1 = create(:item, merchant: @merchant_10)
      @item_2 = create(:item, merchant: @merchant)
      @item_3 = create(:item, merchant: @merchant)
      @item_4 = create(:item, merchant: @merchant)
      @item_5 = create(:item, merchant: @merchant)

      @invoice_1 = create(:invoice, merchant: @merchant_10, customer: @customer_10, updated_at: "2012-03-27 14:54:09 UTC")
      @invoice_2 = create(:invoice, merchant: @merchant, customer: @customer, updated_at: "2012-03-27 14:54:09 UTC")
      @invoice_3 = create(:invoice, merchant: @merchant, customer: @customer, updated_at: "2012-03-17 14:54:09 UTC")
      @invoice_4 = create(:invoice, merchant: @merchant, customer: @customer, updated_at: "2012-03-17 14:54:09 UTC")
      @invoice_5 = create(:invoice, merchant: @merchant, customer: @customer, updated_at: "2012-03-17 14:54:09 UTC")

      @invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 50, item_id: @item_1.id, invoice_id: @invoice_1.id, updated_at: "2012-03-27 14:54:09 UTC")
      @invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 100, item_id: @item_2.id, invoice_id: @invoice_2.id, updated_at: "2012-03-27 14:54:09 UTC")
      @invoice_item_3 = create(:invoice_item, quantity: 3, unit_price: 200, item_id: @item_3.id, invoice_id: @invoice_3.id, updated_at: "2012-03-17 14:54:09 UTC")
      @invoice_item_4 = create(:invoice_item, quantity: 4, unit_price: 1000, item_id: @item_4.id, invoice_id: @invoice_4.id, updated_at: "2012-03-17 14:54:09 UTC")

      @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: "success", updated_at: "2012-03-27 14:54:09 UTC")
      @transaction_2 = create(:transaction, invoice_id: @invoice_2.id, result: "success", updated_at: "2012-03-25 14:54:09 UTC")
      @transaction_3 = create(:transaction, invoice_id: @invoice_3.id, result: "failed", updated_at: "2012-03-27 14:54:09 UTC")
      @transaction_4 = create(:transaction, invoice_id: @invoice_4.id, result: "success", updated_at: "2012-03-17 14:54:09 UTC")
    end
    it "#single_merchant_revenue" do
      expect(@merchant.single_merchant_revenue(@merchant.id).total_revenue).to eq(4200)
      expect(@merchant_10.single_merchant_revenue(@merchant_10.id).total_revenue).to eq(50)
    end
    it "#revenue_by_day" do
      day = "2012-03-27 14:54:09 UTC"
      expect(@merchant.revenue_by_day(day)).to eq(200)
      expect(@merchant_10.revenue_by_day(day)).to eq(50)
    end
    it "#favorite_customer" do
      expect(@merchant.favorite_customer).to eq(@customer)
      expect(@merchant.favorite_customer).to_not eq(@customer_10)
      expect(@merchant_10.favorite_customer).to eq(@customer_10)
    end
  end
end
