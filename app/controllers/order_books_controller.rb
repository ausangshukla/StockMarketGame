class OrderBooksController < ApplicationController
  load_and_authorize_resource :except => ["index", "search", "show"]

  def initialize
    super
    @exchange = Exchange.get("NYSE")
  end 

  # GET /order_books or /order_books.json
  def index
    @order_books = @exchange.all_order_books
  end

  def run_simulation
    OrderSimulator.simulate(params[:security_id], params[:count])
  end

  # GET /order_books/1 or /order_books/1.json
  def show
    @order_book = @exchange.get_order_book(params[:symbol])
  end

  private
  
    # Only allow a list of trusted parameters through.
    def order_book_params
      params.require(:order_book).permit(:symbol, :security_id)
    end
end
