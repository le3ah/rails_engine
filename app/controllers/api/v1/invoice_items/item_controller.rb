class Api::V1::InvoiceItems::ItemController < ApplicationController
  def show
    item = InvoiceItem.find(params[:id]).item
    render json: AssociatedItemSerializer.new(item)
  end
end
