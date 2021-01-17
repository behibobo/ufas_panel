class Admin::UsersController < AdminController
	before_action :authorized, only: []
	    
  def index 
    users = User.order(created_at: :desc)
    render json: users
  end
end
