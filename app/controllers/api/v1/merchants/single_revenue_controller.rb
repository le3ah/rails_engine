class Api::V1::Merchants::SingleRevenueController < ApplicationController
  def show
    merchant = Merchant.find(params[:id])
    if params[:date]
      revenue = Struct.new(:id, :total_revenue)

      merchant_revenue = merchant.revenue_by_day(params[:date])
      this_merchant = revenue.new("#{merchant.id}", merchant_revenue)
    else
      this_merchant = merchant.single_merchant_revenue(merchant)
    end
    render json: SingleMerchantRevenueSerializer.new(this_merchant)
  end
end
