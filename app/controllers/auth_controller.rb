class AuthController < ApplicationController
	before_action :authorized, only: []
	
	def signup
		@user = User.create(user_params)
		if(params[:auth][:referral_code])
			referred = User.find_by(referral_code: params[:auth][:referral_code])
			@user.referred_by_id = referred.id unless referred.nil?
			@user.save
		end
		
		if @user.valid?
			plan = Plan.where(days: 7).first
			account = Account.create(plan: plan, user: @user, valid_to: Date.today + plan.days)			
			token = encode_token({user_id: @user.uuid})
			render json: {user: @user, token: token}
		else
			render json: {error: @user.errors}
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
	
	private

  def user_params
    params.permit(:email, :password)
  end
end
