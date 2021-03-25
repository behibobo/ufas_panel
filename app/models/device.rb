class Device < ApplicationRecord
  belongs_to :user

	enum device_type: [:mobile, :tv, :desktop]
end
