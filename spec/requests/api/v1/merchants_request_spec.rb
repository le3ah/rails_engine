require 'rails_helper'

describe "Merchants API" do
  it "sends a lits of merchants" do
    create_list(:merchant, 3)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants.count).to eq(1)
    expect(merchants["data"].count).to eq(3)

  end
  xit "can get one merchant by its id" do
    id = create(:merchant).id.to_s

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(id)
  end
  context "parameter find search" do
    xit "can find a single object by id" do
      id = create(:merchant).id.to_s

      get "/api/v1/merchants/find?id=#{id}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"]["id"]).to eq(id)
    end
    xit "can find a single object by name" do
      name = create(:merchant).name

      get "/api/v1/merchants/find?name=#{name}"
      merchant = JSON.parse(response.body)
      expect(response).to be_successful

      expect(merchant["data"]["attributes"]["name"]).to eq(name)
    end
  end
  context "parameter find all search" do
    xit "can find all matches based on id" do
      id = create(:merchant).id

      get "/api/v1/merchants/find_all?id=#{id}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"][0]["attributes"]["id"]).to eq(id)
    end
    xit "can find all matches based on name" do
      customer_1 = create(:merchant, name: "George")
      customer_2 = create(:merchant, name: "George")
      customer_3 = create(:merchant, name: "George")
      customer_4 = create(:merchant, name: "Sam")

      get "/api/v1/merchants/find_all?name=#{customer_1.name}"

      merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(merchant["data"][0]["attributes"]["name"]).to eq(customer_1.name)
      expect(merchant["data"][1]["attributes"]["name"]).to eq(customer_1.name)
      expect(merchant["data"][-1]["attributes"]["name"]).to eq(customer_1.name)
      expect(merchant["data"].count).to eq(3)
    end
  end
  xit "returns a random resource" do
    customer_1 = create(:merchant)
    customer_2 = create(:merchant)

    get "/api/v1/merchants/random"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful

    expect(merchant.count).to eq(1)
    expect(merchant["data"]["type"]).to eq("merchant")
  end
end
