class Api::V1::InvoiceItems::InvoiceController < ApplicationController
  def show
    invoice = InvoiceItem.find(params[:id]).invoice
    render json: AssociatedInvoiceSerializer.new(invoice)
  end
end
