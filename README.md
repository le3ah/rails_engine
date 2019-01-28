## Rails Engine
This is a project designed to use Rails and ActiveRecord in order to build a JSON API which exposes the SalesEngine data schema.

## Learning Goals
- Learn how to build Single-Responsibility controllers to provide a well-designed and versioned API
- Learn how to use controller tests to drive your design
- Use Ruby and ActiveRecord to perform more complicated business intelligence


* Ruby version - ruby 2.4.5

* I used RSpec tests to drive my development; SpecHarness is also available
![testing](simplecov.png)

* Table Relationships as follows:
![schema](railsschema.png)

* I imported the database files using an `import.rake` file.  Code example:
```desc "Imports a CSV of all entities"
task :customer_import => :environment do
  CSV.foreach('./db/data/customers.csv', :headers => true ) do |row|
    Customer.create!(row.to_h)
  end
end```
