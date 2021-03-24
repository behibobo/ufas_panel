class Admin::UsersController < AdminController
	before_action :authorized, only: []
	    
  def index 
    total_record = User.where(user_type: "registered").count()
    users = User.where(user_type: "registered").order(created_at: :desc).page(params[:page]).per(params[:page_size])

    if(total_record > 0)
      total_page = (total_record / params[:page_size].to_i).floor 
      total = 1 unless total_page > 0
    else
      total_record= 1
    end
    
    render json: { result: ActiveModel::SerializableResource.new(users), total_record: total_record, total_page: total}
  end

  def show
    user = User.find(params[:id])
    accounts = Account.where(user: user).order(created_at: :desc).limit(10)
    user_servers = UserServer.where(user_id: params[:id]).order(created_at: :desc).limit(10)
    render json: { 
      user: ActiveModel::SerializableResource.new(user), 
      accounts: ActiveModel::SerializableResource.new(accounts),
      user_servers: ActiveModel::SerializableResource.new(user_servers)
    }
  end
end
