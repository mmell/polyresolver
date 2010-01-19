require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  test "public_key_prefix not nil" do
    p = Player.create(:signifier => 'mike')
    assert_not_nil( p.public_key_prefix )
  end

  test "public_key valid" do
    p = Player.create(:signifier => 'mike')
    assert_equal(0, p.public_key.index(Player::PublicKeyDelimiters[:begin]), p.public_key )
    assert_equal(p.public_key.length() - 24, p.public_key.index(Player::PublicKeyDelimiters[:end]), p.public_key )
  end

  test "public_key_prefix matches key" do
    p = Player.create(:signifier => 'mike')
    assert_equal(0, p.public_key.index(p.public_key_prefix) )
  end

  test "players transports" do
    p = Player.create!(Factory.attributes_for(:player))
    t = Transport.create!(:transport => 'email', :address => Factory.next(:email), :player => p )
    assert_equal( t, p.transports(true).first)
  end
  
  test "players transport" do
    p = Factory.create(:player)
    assert_difference("Player.find(p.id).transports.count") {
      Transport.create(:transport => 'email', :address => 'mike@nthwave.net', :player => p )
    }
  end
  
  test "players transports create" do
    p = Factory.create(:player)
    assert_difference("Player.find(p.id).transports.count") {
      p.transports.create(:transport => 'email', :address => 'mike@nthwave.net' )
    }
  end
  
  test "players members" do
    p1 = Factory.create(:player)
    assert(p1.valid?)
    assert_difference("Player.find(p1.id).members.count") {
      p2 = Factory.create(:player, :community_id => p1.id )
      assert(p2.valid?)
    }
  end
  
  test "destroys members" do
    p = Factory.create(:player)
    p2 = Factory.create(:player, :community_id => p.id )
    assert_nothing_raised(ActiveRecord::RecordNotFound) { Player.find(p2.id) }
    p.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Player.find(p2.id) }
  end
  
  test "players peers" do
    p = Factory.create(:player)
    assert_difference("Resolver.count") {
      assert_difference("Peer.count") {
        Factory.create(:peer, :player => p, :resolver => Factory.create(:resolver, :public_key => DevPlayer[:public_key]) )
      }
    }
  end
    
  test "community_chain and community_signifier" do
    p1 = Factory.create(:player)
    assert_equal([p1.signifier], p1.community_chain)
    assert_equal(p1.signifier, p1.community_signifier)

    p2 = Factory.create(:player, :community => p1)
    assert_equal([p2.signifier, p1.signifier], p2.community_chain)
    assert_equal([p2.signifier, p1.signifier].join(Player::SignifierSep), p2.community_signifier)
  end
  
  test "class_find_by_signifier" do
    p1 = Factory.create(:player)
    p2 = Factory.create(:player, :community_id => p1.id)
    
    assert_equal(p2, Player.find_by_signifier( p2.community_signifier ) )
  end
  
  test "Player pop_uri_peer" do
    uri_parsed = URI.parse( 'http://0.0.0.0:3011/resolve/mikey' )
    result = Player.pop_uri_peer(uri_parsed)
    assert_equal('mikey', result[0])
    assert_equal(URI.parse( 'http://0.0.0.0:3011/resolve' ).to_s, result[1].to_s)

    uri_parsed = URI.parse( 'http://0.0.0.0:3011/resolve/mikey.owen' )
    result = Player.pop_uri_peer(uri_parsed)
    assert_equal('owen', result[0])
    assert_equal(URI.parse( 'http://0.0.0.0:3011/resolve' ).to_s, result[1].to_s)
  end
  
  test "peer_from_peer_url" do
    p = Factory.create(:player)
    peer_url = "#{DevPlayerEndPoint}/resolvers/resolve/#{DevPlayer[:signifier]}"
    assert_difference("Resolver.count") {
      assert_difference("Peer.count") {
        p.peer_from_peer_url( peer_url ).save!
      }
    }
  end
end
