require 'test_helper'

class ResolverTest < ActiveSupport::TestCase

  test "resolver" do
    assert_nothing_raised { Player.create(DevPlayer) } # create in test db. It must be in dev db prior to test run.
  end

  test "public_key_prefix matches key" do
    r = Factory.build(:resolver)
    r.sync_public_key_prefix
    assert_equal( r.public_key[0,256],  r.public_key_prefix )
  end

  test "resolver requries end point" do
    assert_raise(ActiveRecord::RecordInvalid, URI::InvalidURIError) { Factory.create(:resolver, :end_point => nil) }
  end
  
  test "resolver verifies player signing" do 
    player = Player.create(DevPlayer)
    assert_equal(DevPlayer[:public_key], player.public_key)
    player.generate_keypair
    assert_equal(DevPlayer[:public_key], player.public_key)
    resolver = Factory.create(:resolver, :public_key => player.public_key )
    token = resolver.generate_token
    assert( resolver.verify( player.sign(token), token) )
  end
  
end
