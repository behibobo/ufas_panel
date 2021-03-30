class Front::AuthController < ApplicationController
	before_action :authorized, only: []
	
	def signup
		ActiveRecord::Base.transaction do
			
			exist = User.find_by(email: user_params[:email])

			unless exist.nil?
				render json: { message: "email has already been taken" }, status: :unprocessable_entity
				return 
			end
			
			user = User.new(user_params)
			user.activation_code = "555555"
			if user_params[:referral_code] 
				referred = User.find_by(referral_code: user_params[:referral_code])
				user.referred_by_id = referred.id unless referred.nil?
			end	
	

			user.save!
			ActivationMailer.sample_email(user).deliver_later
			plan = Plan.where(days: 7).first
                        account = Account.create(plan: plan, user: user, valid_to: Date.today + plan.days)
			render json: { email: user.email, active: user.active}.to_json

		end
	end

	def activate
		user = User.find_by(email: user_params[:email])
		if user.activation_code == params[:activation_code].to_s
			user.active = true
			user.save
			token = encode_token({user_id: user.uuid})
			render json: { email: user.email, active: user.active, token: token}.to_json
		else
			render json: {error: "activation code is wrong try again"}, status: :unprocessable_entity
		end
		
	end
    
  def signin
		user = User.find_by(email: user_params[:email])
		
		if user && user.authenticate(user_params[:password])
			token = encode_token({user_id: user.uuid})
			render json: { email: user.email, active: user.active, token: token}.to_json
		else
			render json: {error: "Invalid username or password"}, status: :unauthorized
		end
  end

  def uuid_signin
		user = User.find_by(uuid: params[:uuid])
		if user
			token = encode_token({user_id: user.uuid})
			render json: {user: { email: user.email, active: user.active, token: user.token}.to_json }
		else
			render json: {error: "Invalid username or password"}, status: :unauthorized
		end
	end


	def forget_password
		@user = User.find_by!(email: params[:email])
		@user.activation_code = "555555"

		#email the new activation code
		@user.save
		render json: {result: true}
	end

	def validate_code
		@user = User.find_by!(email: params[:email])
		if @user.activation_code = params[:activation_code]
			render json: {result: true}
		else
			render json: {result: false}, status: :unauthorized
		end
	end

	def change_password
		@user = User.find_by!(email: params[:email])
		@user.password = params[:password]
		@user.save!
		render json: {result: true}
	end
	
	private

  def user_params
    params.require(:auth).permit(:email, :password, :referral_code, :activation_code)
  end
end
