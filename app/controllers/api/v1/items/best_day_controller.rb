class Api::V1::Items::BestDayController < ApplicationController
  def show
    item = Item.find(params[:id])

    item_date = item.best_day
    render json: BestDaySerializer.new(item_date)
  end
end
