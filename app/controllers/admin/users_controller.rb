class Admin::UsersController < AdminController
	before_action :authorized, only: []
	    
  def index 
    users = User.order(created_at: :desc)
    users = users.where(user_type: "registered")
    users = users.where('email like ?', "%#{params[:keyword]}%") if params[:keyword]

    total_record = users.count

    users = users.page(params[:page]).per(params[:page_size])
    total = 1
    if(total_record > 0)
      total_page = (total_record.to_f / params[:page_size].to_i).ceil 
      total = total_page if total_page > 0
    end
    
    render json: { result: ActiveModel::SerializableResource.new(users), total_record: total_record, total_page: total}
  end

  def show
    user = User.find(params[:id])
    accounts = Account.where(user: user).order(created_at: :desc).limit(10)
    user_servers_ids = UserServer.where(user_id: params[:id]).order(created_at: :desc).limit(10).pluck('server_id')
    
    user_servers = Server.where(id: user_servers_ids)
    render json: { 
      user: ActiveModel::SerializableResource.new(user), 
      accounts: ActiveModel::SerializableResource.new(accounts),
      user_servers: ActiveModel::SerializableResource.new(user_servers)
    }
  end
end
