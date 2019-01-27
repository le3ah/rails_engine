class Api::V1::TransactionsController < ApplicationController
  def index
    render json: TransactionSerializer.new(Transaction.all)
  end
end
