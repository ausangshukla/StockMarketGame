class PositionsController < ApplicationController
  load_and_authorize_resource :except => ["index", "search"]

  # GET /positions or /positions.json
  def index
    @positions = Position.all.includes(:user)
  end

  # GET /positions/1 or /positions/1.json
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions or /positions.json
  def create
    @position = Position.new(position_params)

    respond_to do |format|
      if @position.save
        format.html { redirect_to @position, notice: "Position was successfully created." }
        format.json { render :show, status: :created, location: @position }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /positions/1 or /positions/1.json
  def update
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to @position, notice: "Position was successfully updated." }
        format.json { render :show, status: :ok, location: @position }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1 or /positions/1.json
  def destroy
    @position.destroy
    respond_to do |format|
      format.html { redirect_to positions_url, notice: "Position was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def position_params
      params.require(:position).permit(:name, :user_id, :security_id, :symbol, :quantity, :average_cost, :current_value, :eod_value)
    end
end
