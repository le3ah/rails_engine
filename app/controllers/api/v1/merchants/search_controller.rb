class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if params[:id]
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    elsif params[:name]
      render json: MerchantSerializer.new(Merchant.where("name ILIKE  '#{params[:name]}'"))
    end
  end
  def index
    if params[:id]
      render json: MerchantSerializer.new(Merchant.where(id: params[:id]))
    elsif params[:name]
      render json: MerchantSerializer.new(Merchant.where("name ILIKE  '#{params[:name]}'"))
    end
  end
end
