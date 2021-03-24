class Admin::AdminAuthController < AdminController
	before_action :authorized, only: []
	    
  def signin
		@admin = Admin.find_by(username: params[:username])
		if @admin && @admin.authenticate(params[:password])
			token = encode_token({admin_id: @admin.uuid})
			render json: {token: token, username: @admin.username}
		else
			render json: {error: "Invalid username or password"}, status: :unauthorized
		end
	end
end
