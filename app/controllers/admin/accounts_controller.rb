class Admin::AccountsController < AdminController
    before_action :set_account, only: [:show, :update, :destroy]
  
    # GET /accounts
    def index
      accounts = Account.order(created_at: :desc)

      accounts = accounts.joins(:user).where('users.email like ?', "%#{params[:keyword]}%") if params[:keyword]

      accounts = accounts.where('valid_to > ?' , Date.today) if params[:active]
      accounts = accounts.where('created_at > ?' , params[:from_date]) if params[:from_date]
      accounts = accounts.where('created_at < ?' , params[:to_date]) if params[:to_date]
      total_record = accounts.count

      accounts = accounts.page(params[:page]).per(params[:page_size])
      total = 1
      if(total_record > 0)
        total_page = (total_record.to_f / params[:page_size].to_i).ceil 
        total = total_page if total_page > 0
    end
    
    render json: { result: ActiveModel::SerializableResource.new(accounts), total_record: total_record, total_page: total}
    end
  
  end
  