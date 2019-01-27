class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def find_items
    invoice_items.map do |ii|
      Item.find(ii.item_id)
    end
  end
end
