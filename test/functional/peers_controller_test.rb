require 'test_helper'

class PeersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:peers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create peer" do
    assert_difference('Peer.count') do
      post :create, :peer => { }
    end

    assert_redirected_to peer_path(assigns(:peer))
  end

  test "should show peer" do
    get :show, :id => peers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => peers(:one).to_param
    assert_response :success
  end

  test "should update peer" do
    put :update, :id => peers(:one).to_param, :peer => { }
    assert_redirected_to peer_path(assigns(:peer))
  end

  test "should destroy peer" do
    assert_difference('Peer.count', -1) do
      delete :destroy, :id => peers(:one).to_param
    end

    assert_redirected_to peers_path
  end
end
