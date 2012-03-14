require 'test_helper'

class FrooblesControllerTest < ActionController::TestCase
  setup do
    @frooble = froobles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:froobles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create frooble" do
    assert_difference('Frooble.count') do
      post :create, frooble: @frooble.attributes
    end

    assert_redirected_to frooble_path(assigns(:frooble))
  end

  test "should show frooble" do
    get :show, id: @frooble
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @frooble
    assert_response :success
  end

  test "should update frooble" do
    put :update, id: @frooble, frooble: @frooble.attributes
    assert_redirected_to frooble_path(assigns(:frooble))
  end

  test "should destroy frooble" do
    assert_difference('Frooble.count', -1) do
      delete :destroy, id: @frooble
    end

    assert_redirected_to froobles_path
  end
end
