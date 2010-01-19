require 'test_helper'

class PeerTest < ActiveSupport::TestCase

  test "peer" do
    resolver = Factory.create(:resolver, :public_key => DevPlayer[:public_key]) 
    assert_nothing_raised { Peer.create!( :signifier => Factory.next(:signifier), :player => Factory.create(:player), :resolver => resolver ) }
  end
  
  test "Peer split_peer_url" do
    uri_parsed = URI.parse( 'http://0.0.0.0:3011/resolve/mikey' )
    result = Peer.split_peer_url(uri_parsed)
    assert_equal('mikey', result[0])
    assert_equal(URI.parse( 'http://0.0.0.0:3011/resolve' ).to_s, result[1].to_s)

    uri_parsed = URI.parse( 'http://0.0.0.0:3011/resolve/mikey.owen' )
    result = Peer.split_peer_url(uri_parsed)
    assert_equal('owen', result[0])
    assert_equal(URI.parse( 'http://0.0.0.0:3011/resolve' ).to_s, result[1].to_s)
  end
  
  test "peer unique signifier" do
    resolver = Factory.create(:resolver, :public_key => DevPlayer[:public_key]) 
    peer = Peer.create!( 
      :signifier => Factory.next(:signifier), 
      :player => Factory.create(:player), 
      :resolver => resolver
    )
    assert_nothing_raised(ActiveRecord::RecordInvalid) { 
      Peer.create!( :signifier => peer.signifier, :player => peer.player, :resolver => resolver ) 
    }
  end
  
  test "peer requires player" do
    assert_raise(ActiveRecord::RecordInvalid) { Peer.create!( :signifier => Factory.next(:signifier), :resolver => Factory.create(:resolver) ) }
  end
  
  test "peer requires resolver" do
    assert_raise(ActiveRecord::RecordInvalid) { Peer.create!( :signifier => Factory.next(:signifier), :player => Factory.create(:player) ) }
  end
  
end
