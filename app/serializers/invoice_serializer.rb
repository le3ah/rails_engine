class InvoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :customer_id, :merchant_id, :status

  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
end
