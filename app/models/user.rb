class User < ApplicationRecord
	has_secure_password
	before_create :generate_uuid
	before_create :generate_referral_code
	has_many :accounts
	belongs_to :referred_by, foreign_key: "referred_by_id", class_name: "User", optional: true

	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
	validates_uniqueness_of :email

	def generate_uuid
		begin
			self.uuid = SecureRandom.hex(16)[0..15]
		end while self.class.exists?(uuid: uuid)
	end

	def generate_referral_code
		begin
			self.referral_code = 10.times.map{rand(10)}.join
		end while self.class.exists?(referral_code: referral_code)
	end

	def current_account
		acc = self.accounts.order(created_at: :desc)
		if acc.any?
			return acc.first
		else
			return nil
		end
	end
end
