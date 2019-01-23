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
  context "parameter find search" do
    it "can find a single object by id" do
      id = create(:customer).id.to_s

      get "/api/v1/customers/find?id=#{id}"

      customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(customer["data"]["id"]).to eq(id)
    end
    it "can find a single object by first name" do
      first_name = create(:customer).first_name

      get "/api/v1/customers/find?first_name=#{first_name}"
      customer = JSON.parse(response.body)
      expect(response).to be_successful

      expect(customer["data"]["attributes"]["first_name"]).to eq(first_name)
    end
    it "can find a single object by last name" do
      last_name = create(:customer).last_name

      get "/api/v1/customers/find?last_name=#{last_name}"
      customer = JSON.parse(response.body)
      expect(response).to be_successful

      expect(customer["data"]["attributes"]["last_name"]).to eq(last_name)
    end
  end
  context "parameter find all search" do
    it "can find all matches based on id" do
      id = create(:customer).id

      get "/api/v1/customers/find_all?id=#{id}"

      customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(customer["data"][0]["attributes"]["id"]).to eq(id)
    end
    it "can find all matches based on first_name" do
      first_name = create(:customer).first_name

      get "/api/v1/customers/find_all?first_name=#{first_name}"

      customer = JSON.parse(response.body)
      expect(response).to be_successful
      expect(customer["data"][0]["attributes"]["first_name"]).to eq(first_name)
    end
  end
end
