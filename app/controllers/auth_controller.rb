class AuthController < ApplicationController
	before_action :authorized, only: []
	
	def signup
		@user = User.create(user_params)
		if @user.valid?
			token = encode_token({user_id: @user.id})
			render json: {user: @user, token: token}
		else
			render json: {error: @user.errors}
		end
	end
    
  def signin
		@user = User.find_by(username: params[:username])
		if @user && @user.authenticate(params[:password])
			token = encode_token({user_id: @user.id})
			render json: {token: token}
		else
			render json: {error: "Invalid username or password"}
		end
	end
	
	private

  def user_params
    params.permit(:email, :password)
  end
end
