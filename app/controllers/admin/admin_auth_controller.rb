class Admin::AdminAuthController < ApiController
	before_action :authorized, only: []
	    
  def signin
		@admin = Admin.find_by(username: params[:username])
		if @admin && @admin.authenticate(params[:password])
			token = encode_token({admin_id: @admin.uuid})
			render json: {token: token, admin: @admin}
		else
			render json: {error: "Invalid username or password"}
		end
	end
end
