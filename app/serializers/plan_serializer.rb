class PlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :days, :price, :purchases_count

  def purchases_count
    Account.where(plan: object).count
  end
end
