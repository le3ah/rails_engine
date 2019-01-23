require 'rails_helper'

describe "Customers API" do
  it "sends a lits of customers" do
    create_list(:customer, 3)
    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)
  end
end
