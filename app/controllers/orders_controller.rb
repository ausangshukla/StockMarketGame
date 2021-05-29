class OrdersController < ApplicationController
  load_and_authorize_resource :except => ["index", "search"]
  
  # GET /orders or /orders.json
  def index
    @orders = Order.all.includes(:user)
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if order_params[:security_id]
      sec = Security.where(id: order_params[:security_id]).first
      if sec
        @order = Order.new(order_params)
        @order.symbol = sec.symbol
      else
        redirect_to securities_path, notice: "No such security"
      end
    else
      redirect_to securities_path, notice: "No security"
    end
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    @order.user_id = current_user.id
    
    respond_to do |format|
      if @order.save
        Exchange.publish("NYSE", @order)
        format.html { redirect_to @order, notice: "Order was successfully sent for execution." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        Exchange.publish("NYSE", @order)
        format.html { redirect_to @order, notice: "Order was sent for modification." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.status = Order::CANCELLED
    @order.save

    Exchange.publish("NYSE", @order)

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was sent for cancellation." }
      format.json { head :no_content }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:user_id, :side, :symbol, :security_id, :quantity, :price, 
        :price_type, :order_type, :qualifier, :linked_short_cover_id, 
        :filled_qty, :open_qty, :status)
    end
end
