class PlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :days, :price
end
