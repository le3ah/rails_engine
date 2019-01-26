class Api::V1::Merchants::CustomerController < ApplicationController
  def show
    merchant = Merchant.find(params[:id]).favorite_customer
    render json: MerchantCustomerSerializer.new(merchant)
  end
end
