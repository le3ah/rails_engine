class Api::V1::Customers::RandomController < ApplicationController
  def show
    customer = Customer.limit(1).order(Arel.sql("RANDOM()")).first
    render json: CustomerSerializer.new(customer)
  end
end
