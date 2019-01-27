class Api::V1::Merchants::InvoicesController < ApplicationController
  def index
    invoices = Merchant.find(params[:id]).invoices
    render json: InvoiceSerializer.new(invoices)
  end
end
