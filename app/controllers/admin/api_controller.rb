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
    accounts = Account.joins(:plan).group('plans.name').group_by_month(:created_at).count
    dates = accounts.map {|acc| acc.first.last.to_s }

    data_numbers = accounts.map {|acc| [acc.first.first, acc.last]}

    data = []
    Plan.all.each do |plan|
      next if plan.name == 'gift'
      item = { 
        label: plan.name,
        values: accounts.to_a.select {|acc| acc.last if acc.first.first == plan.name}.map {|m| m.last }
      }
      
       data << item
    end

    render json: {
      dates: dates, data: data
    }
  end
end
