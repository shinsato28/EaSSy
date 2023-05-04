require "test_helper"

class Public::NovelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_novels_index_url
    assert_response :success
  end

  test "should get show" do
    get public_novels_show_url
    assert_response :success
  end

  test "should get new" do
    get public_novels_new_url
    assert_response :success
  end

  test "should get confirm" do
    get public_novels_confirm_url
    assert_response :success
  end

  test "should get edit" do
    get public_novels_edit_url
    assert_response :success
  end
end
