class Customer < ApplicationRecord
  has_many :invoices
  has_many :merchants, through: :invoices

  def favorite_merchant
    Merchant.joins(invoices: :transactions)
    .select("merchants.*, count(transactions.id) AS total_transactions")
    .group(:id)
    .where("transactions.result = ?", "success")
    .order("total_transactions desc")
    .where("invoices.customer_id = #{self.id}")[0]
  end

  def find_transactions
    invoices.map do |invoice|
      Transaction.where(invoice_id: invoice.id)
    end.flatten
  end
end
