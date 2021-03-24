class Admin::ApiController < AdminController
	before_action :authorized, only: []
	    
  def countries
    countries = Country.all
		render json: countries.to_json
  end
end
