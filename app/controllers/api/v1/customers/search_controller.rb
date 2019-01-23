class Api::V1::Customers::SearchController < ApplicationController
  def show
    render json: CustomerSerializer.new(Customer.find(params[:id]))
  end
end
