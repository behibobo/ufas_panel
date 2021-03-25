class Admin::ServersController < AdminController
  before_action :set_server, only: [:show, :update, :destroy]

  # GET /servers
  def index
    servers = Server.order(created_at: :desc)
    servers = servers.where(server_type: params[:server_type]) if params[:server_type]
    servers = servers.where(country_id: params[:country_id]) if params[:country_id]
    servers = servers.where(premium: params[:premium]) if params[:premium]
    render json: servers
  end

  # GET /servers/1
  def show
    render json: @server
  end

  # POST /servers
  def create
    @server = Server.new(server_params)

    if @server.save
      render json: @server, status: :created
    else
      render json: @server.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /servers/1
  def update
    if @server.update(server_params)
      render json: @server
    else
      render json: @server.errors, status: :unprocessable_entity
    end
  end

  # DELETE /servers/1
  def destroy
    @server.destroy
  end

  def countries
    @countries = Country.order(:name)
    render json: @countries
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def server_params
      params.require(:server).permit(:host, :api_key, :port, :ip, :country_id, :server_type, :premium)
    end
end
