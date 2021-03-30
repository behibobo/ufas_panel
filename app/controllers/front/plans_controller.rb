class Front::PlansController < ApplicationController
  before_action :authorized, only: []
  # GET /plans
  def index
    @plans = Plan.all
    render json: @plans
  end
end
