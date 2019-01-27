class Api::V1::Invoices::MerchantController < ApplicationController
  def show
    merchant = Invoice.find(params[:id]).merchant
    render json: AssociatedMerchantSerializer.new(merchant)
  end
end
