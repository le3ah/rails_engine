class Api::V1::Merchants::SingleRevenueController < ApplicationController
  def show
    merchant = Merchant.find(params[:id])
    this_merchant = merchant.single_merchant_revenue(merchant)
    render json: SingleMerchantRevenueSerializer.new(this_merchant)
  end
end
