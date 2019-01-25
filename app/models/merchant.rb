class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  def self.most_revenue(x)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .select("merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) AS total_revenue" )
    .group(:id)
    .where("transactions.result = ?", "success")
    .order("total_revenue desc")
    .limit(x)
  end

  def self.most_items(x)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .select("merchants.*, sum(invoice_items.quantity) AS total_items" )
    .group(:id)
    .where("transactions.result = ?", "success")
    .order("total_items desc")
    .limit(x)
  end

  def self.revenue_date(x)
    InvoiceItem.joins(:invoice)
    .joins(invoice: :transactions)
    .select("sum(invoice_items.unit_price * invoice_items.quantity) AS total_revenue" )
    .where("transactions.result = ?", "success")
    .where("transactions.updated_at = ?", x)
    .group("transactions.updated_at")[0]
  end

  def single_merchant_revenue(id)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .select("merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) AS total_revenue" )
    .group(:id)
    .where("transactions.result = ?", "success")
    .order("total_revenue desc")
    .where(id: id)[0]
  end
end
