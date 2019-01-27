class Api::V1::Customers::InvoicesController < ApplicationController
  def index
    invoices = Customer.find(params[:id]).invoices
    render json: AssociatedInvoiceSerializer.new(invoices)
  end
end
