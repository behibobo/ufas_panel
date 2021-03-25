class Server < ApplicationRecord
	belongs_to :country
	enum server_type: [:ikev, :ovpn]

	has_many :user_servers, dependent: :destroy

	def self.connections(user)
		Server.all.each do |server|
			UserConnection.create(
				user: user,
				server: server,
				username: "behzad",
				password: "1234@qwerB"
			)
		end
	end


	def flag_url
    "https://countryflags.io/#{self.country.code}/shiny/64.png"
  end


	def self.flash_server(premium)
		server = Server.where(premium: premium).sample
		return server
	end


	def popularity
		total = UserServer.count
		server_count = UserServer.where(server: self).count
		((server_count.to_f * 100) / total).round(2)
	end
end
