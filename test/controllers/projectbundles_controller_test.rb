require 'test_helper'

class ProjectbundlesControllerTest < ActionController::TestCase
  setup do
    @projectbundle = projectbundles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projectbundles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create projectbundle" do
    assert_difference('Projectbundle.count') do
      post :create, projectbundle: { active: @projectbundle.active, description: @projectbundle.description, name: @projectbundle.name }
    end

    assert_redirected_to projectbundle_path(assigns(:projectbundle))
  end

  test "should show projectbundle" do
    get :show, id: @projectbundle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @projectbundle
    assert_response :success
  end

  test "should update projectbundle" do
    patch :update, id: @projectbundle, projectbundle: { active: @projectbundle.active, description: @projectbundle.description, name: @projectbundle.name }
    assert_redirected_to projectbundle_path(assigns(:projectbundle))
  end

  test "should destroy projectbundle" do
    assert_difference('Projectbundle.count', -1) do
      delete :destroy, id: @projectbundle
    end

    assert_redirected_to projectbundles_path
  end
end
