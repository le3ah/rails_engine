class Api::V1::Invoices::ItemsController < ApplicationController
  def index
    invoice = Invoice.find(params[:id])

    items = invoice.find_items
    render json: ItemSerializer.new(items)
  end
end
