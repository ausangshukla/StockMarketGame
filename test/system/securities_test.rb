require "application_system_test_case"

class SecuritiesTest < ApplicationSystemTestCase
  setup do
    @security = securities(:one)
  end

  test "visiting the index" do
    visit securities_url
    assert_selector "h1", text: "Securities"
  end

  test "creating a Security" do
    visit securities_url
    click_on "New Security"

    fill_in "Day high price", with: @security.day_high_price
    fill_in "Day low price", with: @security.day_low_price
    fill_in "Last trade date", with: @security.last_trade_date
    fill_in "Market cap", with: @security.market_cap
    fill_in "Name", with: @security.name
    fill_in "Opening trade price", with: @security.opening_trade_price
    fill_in "Pe", with: @security.pe
    fill_in "Prev closing price", with: @security.prev_closing_price
    fill_in "Price", with: @security.price
    fill_in "Sec type", with: @security.sec_type
    fill_in "Symbol", with: @security.symbol
    click_on "Create Security"

    assert_text "Security was successfully created"
    click_on "Back"
  end

  test "updating a Security" do
    visit securities_url
    click_on "Edit", match: :first

    fill_in "Day high price", with: @security.day_high_price
    fill_in "Day low price", with: @security.day_low_price
    fill_in "Last trade date", with: @security.last_trade_date
    fill_in "Market cap", with: @security.market_cap
    fill_in "Name", with: @security.name
    fill_in "Opening trade price", with: @security.opening_trade_price
    fill_in "Pe", with: @security.pe
    fill_in "Prev closing price", with: @security.prev_closing_price
    fill_in "Price", with: @security.price
    fill_in "Sec type", with: @security.sec_type
    fill_in "Symbol", with: @security.symbol
    click_on "Update Security"

    assert_text "Security was successfully updated"
    click_on "Back"
  end

  test "destroying a Security" do
    visit securities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Security was successfully destroyed"
  end
end
