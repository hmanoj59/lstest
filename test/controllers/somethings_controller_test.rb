require 'test_helper'

class SomethingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @something = somethings(:one)
  end

  test "should get index" do
    get somethings_url
    assert_response :success
  end

  test "should get new" do
    get new_something_url
    assert_response :success
  end

  test "should create something" do
    assert_difference('Something.count') do
      post somethings_url, params: { something: { instanceid: @something.instanceid, todo_action: @something.todo_action } }
    end

    assert_redirected_to something_url(Something.last)
  end

  test "should show something" do
    get something_url(@something)
    assert_response :success
  end

  test "should get edit" do
    get edit_something_url(@something)
    assert_response :success
  end

  test "should update something" do
    patch something_url(@something), params: { something: { instanceid: @something.instanceid, todo_action: @something.todo_action } }
    assert_redirected_to something_url(@something)
  end

  test "should destroy something" do
    assert_difference('Something.count', -1) do
      delete something_url(@something)
    end

    assert_redirected_to somethings_url
  end
end
