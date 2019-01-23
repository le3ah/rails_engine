require 'csv'

desc "Imports a CSV of all customers"
task :customer_import => :environment do
  filename = File.join Rails.root, '/db/data/customers.csv'
  CSV.foreach(filename, :headers => true ) do |row|
    Customer.create!(row.to_h)
  end
end
