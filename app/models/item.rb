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

  def self.most_quantity_sold(x)
    Item.joins(invoices: [:invoice_items, :transactions])
    .select("items.*, sum(invoice_items.quantity) AS total_quantity")
    .group(:id)
    .where("transactions.result =?", "success")
    .order("total_quantity desc")
    .limit(x)
  end

  def best_day
    Invoice.joins(:invoice_items, :transactions)
    .select("invoices.*, count(invoices.id) AS total_invoices")
    .where("transactions.result = ?", "success")
    .order("total_invoices desc")
    .group(:id)
    .where("invoice_items.item_id = #{self.id}")[0]
    
  end
end
