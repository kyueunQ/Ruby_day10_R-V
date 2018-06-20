require 'test_helper'

class ForwardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forward_index_url
    assert_response :success
  end

  test "should get show" do
    get forward_show_url
    assert_response :success
  end

  test "should get new" do
    get forward_new_url
    assert_response :success
  end

  test "should get edit" do
    get forward_edit_url
    assert_response :success
  end

end
