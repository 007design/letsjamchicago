require "test_helper"

class LetsjamControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get letsjam_index_url
    assert_response :success
  end
end
