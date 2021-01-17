class Account < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  def is_valid?
    Date.today < self.valid_to
  end
end
