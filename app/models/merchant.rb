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
end
