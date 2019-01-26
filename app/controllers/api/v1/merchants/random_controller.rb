class Api::V1::Merchants::RandomController < ApplicationController
  def show
    merchant = Merchant.limit(1).order(Arel.sql("RANDOM()")).first
    render json: MerchantSerializer.new(merchant)
  end
end
