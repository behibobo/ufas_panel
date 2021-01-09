class AccountSerializer < ActiveModel::Serializer
  attributes :id, :started_date, :expire_date, :days_left, :plan, :active

  def started_date
    object.created_at.to_date.to_s
  end

  def expire_date
    object.valid_to.to_s
  end

  def days_left
    (object.valid_to.to_date - Date.today).to_i
  end


  def active
    object.valid_to >= Date.today
  end
end
