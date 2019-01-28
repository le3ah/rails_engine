class BestDaySerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :updated_at

  attributes :best_day do |invoice|
    invoice.updated_at
  end
end
