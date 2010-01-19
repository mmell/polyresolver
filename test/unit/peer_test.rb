require 'test_helper'

class PeerTest < ActiveSupport::TestCase

  test "peer" do
    resolver = Factory.create(:resolver, :public_key => DevPlayer[:public_key]) 
    assert_nothing_raised { Peer.create!( :signifier => Factory.next(:signifier), :player => Factory.create(:player), :resolver => resolver ) }
  end
  
  test "peer unique signifier" do
    resolver = Factory.create(:resolver, :public_key => DevPlayer[:public_key]) 
    signifier = 'signifier'
    peer1 = Peer.create!( 
      :signifier => signifier, 
      :player => Factory.create(:player), 
      :resolver => resolver
    )
    assert_equal("#{signifier}", peer1.signifier)
    peer2 = Peer.create!( :signifier => signifier, :player => peer1.player, :resolver => resolver ) 
    assert_equal("#{signifier}1", peer2.signifier)
  end
  
  test "peer requires player" do
    assert_raise(ActiveRecord::RecordInvalid) { Peer.create!( :signifier => Factory.next(:signifier), :resolver => Factory.create(:resolver) ) }
  end
  
  test "peer requires resolver" do
    assert_raise(ActiveRecord::RecordInvalid) { Peer.create!( :signifier => Factory.next(:signifier), :player => Factory.create(:player) ) }
  end
  
  test "get transport" do
    resolver = Factory.create(:resolver, :public_key => DevPlayer[:public_key]) 
    peer = Factory.create(:player).peers.create!( :signifier => 'peer', :resolver => resolver )
    assert_equal(DevPlayerEmail, peer.get_transport('email') )
  end
end
