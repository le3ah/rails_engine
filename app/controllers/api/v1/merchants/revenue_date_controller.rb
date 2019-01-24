class Api::V1::Merchants::RevenueDateController < ApplicationController
  def show
    merchants = Merchant.revenue_date(params[:date])
    render json: MerchantRevenueDateSerializer.new(merchants)
  end
end
