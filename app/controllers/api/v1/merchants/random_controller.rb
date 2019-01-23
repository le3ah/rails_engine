class Api::V1::Merchants::RandomController < ApplicationController
  def show
    merchant = Merchant.limit(1).order("RANDOM()").first
    render json: MerchantSerializer.new(merchant)
  end
end
