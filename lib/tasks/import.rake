require 'csv'

desc "Imports a CSV of all entities"
task :customer_import => :environment do
  CSV.foreach('./db/data/customers.csv', :headers => true ) do |row|
    Customer.create!(row.to_h)
  end
end
task :merchant_import => :environment do
  CSV.foreach('./db/data/merchants.csv', :headers => true ) do |row|
    Merchant.create!(row.to_h)
  end
end
task :item_import => :environment do
  CSV.foreach('./db/data/items.csv', :headers => true ) do |row|
    Item.create!(row.to_h)
  end
end
task :invoice_import => :environment do
  CSV.foreach('./db/data/invoices.csv', :headers => true ) do |row|
    Invoice.create!(row.to_h)
  end
end
task :invoice_items_import => :environment do
  CSV.foreach('./db/data/invoice_items.csv', :headers => true ) do |row|
    InvoiceItem.create!(row.to_h)
  end
end
task :transaction_import => :environment do
  CSV.foreach('./db/data/transactions.csv', :headers => true ) do |row|
    Transaction.create!(row.to_h)
  end
end
desc "Imports all data from CSV files"
  task :all => :environment do
      CSV.foreach('./db/data/customers.csv', :headers => true ) do |row|
        Customer.create!(row.to_h)
      end

      CSV.foreach('./db/data/merchants.csv', :headers => true ) do |row|
        Merchant.create!(row.to_h)
      end

      CSV.foreach('./db/data/items.csv', :headers => true ) do |row|
        Item.create!(row.to_h)
      end

      CSV.foreach('./db/data/invoices.csv', :headers => true ) do |row|
        Invoice.create!(row.to_h)
      end


      CSV.foreach('./db/data/invoice_items.csv', :headers => true ) do |row|
        InvoiceItem.create!(row.to_h)
      end

      CSV.foreach('./db/data/transactions.csv', :headers => true ) do |row|
        Transaction.create!(row.to_h)
      end
  end
