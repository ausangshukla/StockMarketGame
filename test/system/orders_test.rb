require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "creating a Order" do
    visit orders_url
    click_on "New Order"

    fill_in "Filled qty", with: @order.filled_qty
    fill_in "Linked short cover", with: @order.linked_short_cover_id
    fill_in "Open qty", with: @order.open_qty
    fill_in "Order type", with: @order.order_type
    fill_in "Price", with: @order.price
    fill_in "Price type", with: @order.price_type
    fill_in "Qualifier", with: @order.qualifier
    fill_in "Quantity", with: @order.quantity
    fill_in "Security", with: @order.security_id
    fill_in "Side", with: @order.side
    fill_in "Status", with: @order.status
    fill_in "Symbol", with: @order.symbol
    fill_in "User", with: @order.user_id
    click_on "Create Order"

    assert_text "Order was successfully created"
    click_on "Back"
  end

  test "updating a Order" do
    visit orders_url
    click_on "Edit", match: :first

    fill_in "Filled qty", with: @order.filled_qty
    fill_in "Linked short cover", with: @order.linked_short_cover_id
    fill_in "Open qty", with: @order.open_qty
    fill_in "Order type", with: @order.order_type
    fill_in "Price", with: @order.price
    fill_in "Price type", with: @order.price_type
    fill_in "Qualifier", with: @order.qualifier
    fill_in "Quantity", with: @order.quantity
    fill_in "Security", with: @order.security_id
    fill_in "Side", with: @order.side
    fill_in "Status", with: @order.status
    fill_in "Symbol", with: @order.symbol
    fill_in "User", with: @order.user_id
    click_on "Update Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "destroying a Order" do
    visit orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order was successfully destroyed"
  end
end
