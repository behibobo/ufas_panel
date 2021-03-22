class Api::ApiController < ApplicationController
	
	def account
			render json: current_user.current_account
	end

  def referrer
		if params[:code]
			user = User.find_by(referral_code: params[:code])
			if(user.nil?)
				render json: {result: "wrong code"}, status: :unprocessable_entity
				return 
			end

			render json: { result: user.email }, status: :ok
		end
	end
	
	def email_exists
		if params[:email]
			user = User.find_by(email: params[:email])
			if(user.nil?)
				render json: {result: false}, status: :ok
				return 
			else 
				render json: { result: true }, status: :ok
				return 
			end
		end
  end

  def create_country
	# uri = URI.parse("https://restcountries.eu/rest/v2/all")

    #     response = Net::HTTP.get_response(uri)
    #     hash = JSON.parse(response.body)
    #     Country.destroy_all
    #     hash.each do |c|
    #         Country.create(name: c["name"], region: c["region"], code: c["alpha2Code"])
    #     end
  end

  def servers
		regions = Country.select(:region).distinct

		premium = true

		premium = false if current_user.user_type == "demo"
		premium = false if current_user.current_account.is_valid?

		data = []
		regions.each do |r|
			servers = Server.joins(:country).where(countries: { region: r.region }).where(premium: premium)

			next unless servers.any?

			vpn_servers = []

			servers.each do |server|
				server_data = {
					name: server.country.name,
					country: server.country.name,
					regiom: server.country.region,
					flag: server.flag_url,
					premium: server.premium,
				}

				connection = UserConnection.where(user: current_user, server: server).first
				server_data[:username] = connection.username
				server_data[:password] = connection.password
				

				vpn_servers.push(server_data)
			end

			data.push(
				{
					region: r.region,
					servers: vpn_servers
				})
		end


		recent_servers = []
		recent_servers = current_user.servers.order(created_at: :desc).first(10) if params[:user_id]

		favorites = []
		if params[:user_id]
			favorite_ids = current_user.user_servers.joins(:server).group('user_servers.id').order('Count(user_servers.server_id) DESC').pluck(:server_id)
			ids = favorite_ids.sort_by { |i| favorite_ids.count(i) }.reverse.uniq
		

			ids.each do |idd|
				s = Server.find(idd)
				favorites.push(s) unless favorites.map(&:id).include? idd
			end
		end
		render json: { servers: data, recent_servers: ActiveModel::SerializableResource.new(recent_servers), favorites: ActiveModel::SerializableResource.new(favorites) }, status: :ok
	end


	def user_server
		UserServer.create(user: current_user, server: params[:server_id])
		render json: { result: true }, status: :ok
	end

	def plans
		plans = Plan.where('days > ?', 7)
		render json: plans
	end

	def auto_server

		premium = true

		premium = false if current_user.user_type == "demo"
		premium = false if current_user.current_account.is_valid?

		server = Server.flash_server(premium)

		server_data = {
			name: server.country.name,
			country: server.country.name,
			regiom: server.country.region,
			flag: server.flag_url,
			premium: server.premium,
		}

		connection = UserConnection.where(user: current_user, server: server).first
		server_data[:username] = connection.username
		server_data[:password] = connection.password

		render json: { server: server_data }, status: :ok
	end
end
