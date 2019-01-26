class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.most_revenue(x)
    Item.joins(invoices: [:invoice_items, :transactions])
    .select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) AS total_revenue")
    .group(:id)
    .where("transactions.result = ?", "success")
    .order("total_revenue desc")
    .limit(x)
  end
end
