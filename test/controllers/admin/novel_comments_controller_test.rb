require "test_helper"

class Admin::NovelCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_novel_comments_index_url
    assert_response :success
  end
end
