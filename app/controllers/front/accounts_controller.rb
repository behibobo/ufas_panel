class Front::AccountsController < ApplicationController
	
	def index
		accounts = Account.where(user: current_user).order(created_at: :desc)
		user_servers_ids = UserServer.where(user_id: current_user.id).order(created_at: :desc).limit(10).pluck('server_id')
    devices = Device.where(user: current_user)
    user_servers = Server.where(id: user_servers_ids)
		render json: { 
			user: ActiveModel::SerializableResource.new(current_user),
			accounts: ActiveModel::SerializableResource.new(accounts),
			servers: ActiveModel::SerializableResource.new(user_servers),
			devices: devices,
		}
	end
	
end
