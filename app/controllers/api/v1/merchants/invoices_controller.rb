class Api::V1::Merchants::InvoicesController < ApplicationController
  def index
    invoices = Merchant.find(params[:id]).invoices
    render json: AssociatedInvoiceSerializer.new(invoices)
  end
end
