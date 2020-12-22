class User < ApplicationRecord
	has_secure_password
	before_create :generate_uuid

	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
	validates_uniqueness_of :email

	def generate_uuid
			begin
				self.uuid = SecureRandom.hex(16)
			end while self.class.exists?(uuid: uuid)
	end
end
