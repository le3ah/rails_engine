require 'csv'

desc "Imports a CSV of all entities"
task :customer_import => :environment do
  filename = File.join Rails.root, '/db/data/customers.csv'
  CSV.foreach(filename, :headers => true ) do |row|
    Customer.create!(row.to_h)
  end
end
task :merchant_import => :environment do
  filename = File.join Rails.root, '/db/data/merchants.csv'
  CSV.foreach(filename, :headers => true ) do |row|
    Merchant.create!(row.to_h)
  end
end
task :item_import => :environment do
  filename = File.join Rails.root, '/db/data/items.csv'
  CSV.foreach(filename, :headers => true ) do |row|
    Item.create!(row.to_h)
  end
end
task :invoice_import => :environment do
  filename = File.join Rails.root, '/db/data/invoices.csv'
  CSV.foreach(filename, :headers => true ) do |row|
    Invoice.create!(row.to_h)
  end
end
