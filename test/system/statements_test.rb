require "application_system_test_case"

class StatementsTest < ApplicationSystemTestCase
  setup do
    @statement = statements(:one)
  end

  test "visiting the index" do
    visit statements_url
    assert_selector "h1", text: "Statements"
  end

  test "creating a Statement" do
    visit statements_url
    click_on "New Statement"

    fill_in "Credit", with: @statement.credit
    fill_in "Debit", with: @statement.debit
    fill_in "Net", with: @statement.net
    fill_in "Particulars", with: @statement.particulars
    fill_in "Ref", with: @statement.ref_id
    fill_in "Ref type", with: @statement.ref_type
    fill_in "Stmt type", with: @statement.stmt_type
    fill_in "User", with: @statement.user_id
    click_on "Create Statement"

    assert_text "Statement was successfully created"
    click_on "Back"
  end

  test "updating a Statement" do
    visit statements_url
    click_on "Edit", match: :first

    fill_in "Credit", with: @statement.credit
    fill_in "Debit", with: @statement.debit
    fill_in "Net", with: @statement.net
    fill_in "Particulars", with: @statement.particulars
    fill_in "Ref", with: @statement.ref_id
    fill_in "Ref type", with: @statement.ref_type
    fill_in "Stmt type", with: @statement.stmt_type
    fill_in "User", with: @statement.user_id
    click_on "Update Statement"

    assert_text "Statement was successfully updated"
    click_on "Back"
  end

  test "destroying a Statement" do
    visit statements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Statement was successfully destroyed"
  end
end
