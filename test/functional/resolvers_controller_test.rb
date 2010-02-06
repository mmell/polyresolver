require 'test_helper'

class ResolversControllerTest < ActionController::TestCase
  
  test "class_resolve" do
    player = Factory.create(:player)
    get :resolve, { :id => player.signifier }
    assert_response :success
    assert_equal(player.public_key, @response.body)
  end
  
  test "resolve should get public key" do
    player = Factory.create(:player)
    get :resolve, { :id => player.signifier }
    assert_response :success
    assert_equal(player.public_key, @response.body)
  end

  test "authenticate_end_point" do
    player = Factory.create(:player)
    token = "asdf"
    get :authenticate_end_point, { :public_key => player.public_key, :token => token }
    assert_response :success
    assert_equal(player.sign(token), @response.body)
  end

=begin
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resolvers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resolver" do
    assert_difference('Resolver.count') do
      post :create, :resolver => { }
    end

    assert_redirected_to resolver_path(assigns(:resolver))
  end

  test "should show resolver" do
    get :show, :id => resolvers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => resolvers(:one).to_param
    assert_response :success
  end

  test "should update resolver" do
    put :update, :id => resolvers(:one).to_param, :resolver => { }
    assert_redirected_to resolver_path(assigns(:resolver))
  end

  test "should destroy resolver" do
    assert_difference('Resolver.count', -1) do
      delete :destroy, :id => resolvers(:one).to_param
    end

    assert_redirected_to resolvers_path
  end
=end

end
