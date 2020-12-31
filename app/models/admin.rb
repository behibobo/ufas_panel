class Admin < ApplicationRecord
    has_secure_password

    before_create :generate_uuid

    private
	def generate_uuid
        begin
            self.uuid = SecureRandom.hex(16)
        end while self.class.exists?(uuid: uuid)
	end
end
