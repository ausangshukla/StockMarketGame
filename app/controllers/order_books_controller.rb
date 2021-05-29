class OrderBooksController < ApplicationController
  load_and_authorize_resource :except => ["index", "search", "show"]

  def run_simulation
    OrderSimulator.simulate(params[:security_id], params[:count])
  end

  # GET /order_books/1 or /order_books/1.json
  def show
    @order_book = OrderBook.new(security_id: params[:security_id], symbol: params[:symbol])
  end

  private
  
    # Only allow a list of trusted parameters through.
    def order_book_params
      params.require(:order_book).permit(:symbol, :security_id)
    end
end
