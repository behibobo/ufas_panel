class Admin::ApiController < AdminController
	before_action :authorized, only: []
	    
  def countries
    countries = Country.all
		render json: countries.to_json
  end

  def plans_purchased
    data = []
    accounts = Account.joins(:plan).group('plans.name').count
    accounts.map do |acc|

      next if acc.first == 'gift'

      item = { 
        label: acc.first,
        value: acc.last
       }

       data << item
    end
    render json: data.to_json
  end 

  def accounts
    date = Date.today
    date = Date.parse(params[:date]) if params[:date]
    revenues = []
    data = []
    revenue_data = []
    Plan.order(:days).each do |plan|
      next if plan.name == 'gift'
      counts = []
      (1..31).to_a.each do |day|
        begin
          selected_date = DateTime.new(date.year,date.month,day,0,0,0)
          count = Account.where(created_at: selected_date).count
          counts.push(count)
          if(Plan.order(:days).last == plan)
            revenues.push(Account.where(created_at: selected_date).sum {|s| s.plan.price }.to_f)
          end
          rescue ArgumentError => e
        rescue => exception
        end
          
      end

      item = {
        label: plan.name,
        values: counts
      }


      data.push(item)

    end
    accounts = Account.where('extract(year from created_at) = ? and extract(month from created_at) = ?', date.year, date.month);
    render json: {
      users: User.where('extract(year from created_at) = ? and extract(month from created_at) = ?',date.year, date.month).count,
      accounts: accounts.count,
      revenue: accounts.sum {|s| s.plan.price },
      dates: (1..31).to_a, 
      data: data,
      revenue_data: revenues,
    }
  end

  def recent_accounts
    recent_accounts = Account.order(created_at: :desc).first(30)
    almost_expire_accounts = Account.order(valid_to: :desc).where('valid_to > ?', Date.today - 2.week).first(30)

    render json: {
      recent_accounts: ActiveModel::SerializableResource.new(recent_accounts), 
      almost_expire_accounts: ActiveModel::SerializableResource.new(almost_expire_accounts)
    }
  end


  def user_servers
    data = []

    Server.all.each do |server|

      users_id = UserServer.where(server: server).pluck(:user_id)
        
      user_count = User.where(id: users_id).where(online: true).count
      item = { 
        server: ActiveModel::SerializableResource.new(server),
        count: user_count
       }
       data << item
    end

    render json: data.to_json
  end


  def dates
    start = Account.order(created_at: :asc).first
    render json: {start: start , now: Date.today}
  end
end
