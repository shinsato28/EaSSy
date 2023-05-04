require "test_helper"

class Public::NovelCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_novel_comments_index_url
    assert_response :success
  end

  test "should get edit" do
    get public_novel_comments_edit_url
    assert_response :success
  end
end
