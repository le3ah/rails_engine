class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if params[:id]
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    elsif params[:name]
      render json: MerchantSerializer.new(Merchant.find_by("name ILIKE  '#{params[:name]}'"))
    elsif params[:created_at]
      render json: MerchantSerializer.new(Merchant.find_by(created_at: params[:created_at]))      
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
