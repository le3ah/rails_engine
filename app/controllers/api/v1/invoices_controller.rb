class Api::V1::InvoicesController < ApplicationController
  def index
    render json: InvoiceSerializer.new(Invoice.all)
  end
end
