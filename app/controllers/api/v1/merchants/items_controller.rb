class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    items = Merchant.find(params[:id]).items
    render json: ItemSerializer.new(items)
  end
end
