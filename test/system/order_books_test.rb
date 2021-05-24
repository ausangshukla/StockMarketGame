require "application_system_test_case"

class OrderBooksTest < ApplicationSystemTestCase
  setup do
    @order_book = order_books(:one)
  end

  test "visiting the index" do
    visit order_books_url
    assert_selector "h1", text: "Order Books"
  end

  test "creating a Order book" do
    visit order_books_url
    click_on "New Order Book"

    fill_in "Security", with: @order_book.security_id
    fill_in "Symbol", with: @order_book.symbol
    click_on "Create Order book"

    assert_text "Order book was successfully created"
    click_on "Back"
  end

  test "updating a Order book" do
    visit order_books_url
    click_on "Edit", match: :first

    fill_in "Security", with: @order_book.security_id
    fill_in "Symbol", with: @order_book.symbol
    click_on "Update Order book"

    assert_text "Order book was successfully updated"
    click_on "Back"
  end

  test "destroying a Order book" do
    visit order_books_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order book was successfully destroyed"
  end
end
