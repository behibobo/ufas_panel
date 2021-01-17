class Api::ApiController < ApplicationController
	skip_before_action :authorized, only: [:referrer,:email_exists, :servers]
	
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
		data = []
		regions.each do |r|
			servers = Server.joins(:country).where(countries: { region: r.region })
			.where(premium: params[:premium])
			
			next unless servers.any?

			if servers.any? 
				data.push(
					{
						region: r.region,
						servers: ActiveModel::SerializableResource.new(servers)
					})
			end
		end

		render json: data.to_json
	end

	def plans
		plans = Plan.where('days > ?', 7)
		render json: plans
	end
end
