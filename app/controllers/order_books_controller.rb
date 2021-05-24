class OrderBooksController < ApplicationController
  before_action :set_order_book, only: %i[ show edit update destroy ]

  # GET /order_books or /order_books.json
  def index
    @order_books = OrderBook.all
  end

  # GET /order_books/1 or /order_books/1.json
  def show
  end

  # GET /order_books/new
  def new
    @order_book = OrderBook.new
  end

  # GET /order_books/1/edit
  def edit
  end

  # POST /order_books or /order_books.json
  def create
    @order_book = OrderBook.new(order_book_params)

    respond_to do |format|
      if @order_book.save
        format.html { redirect_to @order_book, notice: "Order book was successfully created." }
        format.json { render :show, status: :created, location: @order_book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_books/1 or /order_books/1.json
  def update
    respond_to do |format|
      if @order_book.update(order_book_params)
        format.html { redirect_to @order_book, notice: "Order book was successfully updated." }
        format.json { render :show, status: :ok, location: @order_book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_books/1 or /order_books/1.json
  def destroy
    @order_book.destroy
    respond_to do |format|
      format.html { redirect_to order_books_url, notice: "Order book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_book
      @order_book = OrderBook.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_book_params
      params.require(:order_book).permit(:symbol, :security_id)
    end
end
