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

  def revenue_by_day(day)
    InvoiceItem.joins(:invoice)
    .joins(invoice: :transactions)
    .where("invoices.updated_at >= '#{day}' AND invoices.updated_at < '#{day}'::date + '1 day'::interval")
    .where("transactions.result = ?", "success")
    .where("invoices.merchant_id = #{id}")
    .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def favorite_customer
    Customer.joins(invoices: [:invoice_items, :transactions])
    .select("customers.*, count(transactions.id) AS total_transactions" )
    .group(:id)
    .where("transactions.result = ?", "success")
    .order("total_transactions desc")
    .where("invoices.merchant_id = #{self.id}")[0]
  end
end
