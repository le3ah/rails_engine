require 'rails_helper'

describe "Customers API" do
  it "sends a lits of customers" do
    create_list(:customer, 3)
    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers.count).to eq(1)
    expect(customers["data"].count).to eq(3)

  end
  it "can get one customer by its id" do
    id = create(:customer).id.to_s

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(id)
  end
  context "parameter search" do
    it "can find a single object by id" do
      id = create(:customer).id.to_s

      get "/api/v1/customers/find?id=#{id}"

      customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(customer["data"]["id"]).to eq(id)
    end
    xit "can find a single object by name" do
      name = create(:customer).name

      get "/api/v1/customers/find?name=#{name}"
      customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(customer["data"]["name"]).to eq(name)
    end
  end
end
