class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result

  belongs_to :invoice
end
