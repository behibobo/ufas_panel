class Admin::PlansController < AdminController
    before_action :set_plan, only: [:show, :update, :destroy]
  
    # GET /plans
    def index
      plans = Plan.order(:days)
      render json: plans
    end
  
    # GET /plans/1
    def show
      render json: @plan
    end
  
    # POST /plans
    def create
      @plan = Plan.new(plan_params)
  
      if @plan.save
        render json: @plan, status: :created
      else
        render json: @plan.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /plans/1
    def update
      if @plan.update(plan_params)
        render json: @plan
      else
        render json: @plan.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /plans/1
    def destroy
      @plan.destroy
    end
  
    def countries
      @countries = Country.order(:name)
      render json: @countries
    end
    
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_plan
        @plan = Plan.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def plan_params
        params.require(:plan).permit(:name, :days, :price,)
      end
  end
  