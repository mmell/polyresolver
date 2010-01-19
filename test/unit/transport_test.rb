require 'test_helper'

class TransportTest < ActiveSupport::TestCase

  test "player required" do
    assert_raise(ActiveRecord::RecordInvalid) { Transport.create!(:address => 'mike@nthwave.net' ) }
    assert_nothing_raised(ActiveRecord::RecordInvalid) { 
      Transport.create!(:transport => 'email', :address => 'mike@nthwave.net', :player => Factory.create(:player) ) 
    }
  end
  
  test "player can make polymorphic transport" do
    p = Factory.create(:player) 
    assert_nothing_raised(ActiveRecord::RecordInvalid) { 
      p.transports.create(:transport => 'email', :address => 'mike0001@nthwave.net' ) 
    }
  end
    
  test "find email" do
    p = Factory.create(:player)
    e = Transport.create(:transport => 'email', :address => 'mike@nthwave.net', :player => p )
    assert(e.valid?)
    assert_equal(e, Player.find(p.id).transports.first)
  end
  
  test "find transport with unset transport" do
    p = Factory.create(:player)
    assert_nil(p.transports.first)
  end
  
  test "find transport with bad transport" do
    p = Factory.create(:player)
    assert_raise(NoMethodError) {p.transports.noop}
  end
  
end
