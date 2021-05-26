require "test_helper"

class StatementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @statement = statements(:one)
  end

  test "should get index" do
    get statements_url
    assert_response :success
  end

  test "should get new" do
    get new_statement_url
    assert_response :success
  end

  test "should create statement" do
    assert_difference('Statement.count') do
      post statements_url, params: { statement: { credit: @statement.credit, debit: @statement.debit, net: @statement.net, particulars: @statement.particulars, ref_id: @statement.ref_id, ref_type: @statement.ref_type, stmt_type: @statement.stmt_type, user_id: @statement.user_id } }
    end

    assert_redirected_to statement_url(Statement.last)
  end

  test "should show statement" do
    get statement_url(@statement)
    assert_response :success
  end

  test "should get edit" do
    get edit_statement_url(@statement)
    assert_response :success
  end

  test "should update statement" do
    patch statement_url(@statement), params: { statement: { credit: @statement.credit, debit: @statement.debit, net: @statement.net, particulars: @statement.particulars, ref_id: @statement.ref_id, ref_type: @statement.ref_type, stmt_type: @statement.stmt_type, user_id: @statement.user_id } }
    assert_redirected_to statement_url(@statement)
  end

  test "should destroy statement" do
    assert_difference('Statement.count', -1) do
      delete statement_url(@statement)
    end

    assert_redirected_to statements_url
  end
end
