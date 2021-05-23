require "test_helper"

class SecuritiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @security = securities(:one)
  end

  test "should get index" do
    get securities_url
    assert_response :success
  end

  test "should get new" do
    get new_security_url
    assert_response :success
  end

  test "should create security" do
    assert_difference('Security.count') do
      post securities_url, params: { security: { day_high_price: @security.day_high_price, day_low_price: @security.day_low_price, last_trade_date: @security.last_trade_date, market_cap: @security.market_cap, name: @security.name, opening_trade_price: @security.opening_trade_price, pe: @security.pe, prev_closing_price: @security.prev_closing_price, price: @security.price, sec_type: @security.sec_type, symbol: @security.symbol } }
    end

    assert_redirected_to security_url(Security.last)
  end

  test "should show security" do
    get security_url(@security)
    assert_response :success
  end

  test "should get edit" do
    get edit_security_url(@security)
    assert_response :success
  end

  test "should update security" do
    patch security_url(@security), params: { security: { day_high_price: @security.day_high_price, day_low_price: @security.day_low_price, last_trade_date: @security.last_trade_date, market_cap: @security.market_cap, name: @security.name, opening_trade_price: @security.opening_trade_price, pe: @security.pe, prev_closing_price: @security.prev_closing_price, price: @security.price, sec_type: @security.sec_type, symbol: @security.symbol } }
    assert_redirected_to security_url(@security)
  end

  test "should destroy security" do
    assert_difference('Security.count', -1) do
      delete security_url(@security)
    end

    assert_redirected_to securities_url
  end
end
