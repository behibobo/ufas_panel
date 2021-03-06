class AuthController < ApplicationController
	before_action :authorized, only: []
	
	def signup
		ActiveRecord::Base.transaction do
			@user = User.new(user_params)
			if(params[:auth][:referral_code])
				referred = User.find_by(referral_code: params[:auth][:referral_code])
				@user.referred_by_id = referred.id unless referred.nil?
			end
			
			#for now it is 555555
			@user.activation_code = "555555"
			#email the activation code

			if @user.valid?
				@user.save!
				ActivationMailer.sample_email(@user).deliver_later
				Server.connections(@user)
				plan = Plan.where(days: 7).first
				account = Account.create(plan: plan, user: @user, valid_to: Date.today + plan.days)			
				token = encode_token({user_id: @user.uuid})
				render json: {user: @user, token: token}
			else
				render json: {error: @user.errors}, status: :unprocessable_entity
			end
		end
	end

	def activate
		@user = User.find_by(email: params[:email])
		if @user.activation_code == params[:activation_code]
			@user.active = true
			@user.save
			token = encode_token({user_id: @user.uuid})
			render json: {user: @user, token: token}
		else
			render json: {error: "activation code is wrong try again"}, status: :unprocessable_entity
		end
		
	end
    
  def signin
		@user = User.find_by(email: params[:email])
		
		if @user && @user.authenticate(params[:password])
			token = encode_token({user_id: @user.uuid})
			render json: {token: token, user: @user}
		else
			render json: {error: "Invalid username or password"}, status: :unauthorized
		end
  end

  def uuid_signin
		@user = User.find_by(uuid: params[:uuid])
		if @user
			token = encode_token({user_id: @user.uuid})
			render json: {token: token, user: @user}
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



	def validate_referral
		user = User.find_by(referral_code: params[:referral_code])
		if user.nil?
			render json: {result: false}
		else
			render json: {result: true, email: user.email }
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
    params.permit(:email, :password, :referral_code)
  end
end
