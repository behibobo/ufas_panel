class Server < ApplicationRecord
	belongs_to :country
	enum server_type: [:ikev, :ovpn]


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
end
