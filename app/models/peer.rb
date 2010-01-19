class Peer < ActiveRecord::Base
  belongs_to :player
  belongs_to :resolver

  validates_uniqueness_of :signifier, :scope => :player_id

  validates_associated :player
  validates_presence_of :player_id

  validates_associated :resolver
  validates_presence_of :resolver_id

  before_validation :unique_signifier

  def unique_signifier
    base = self.signifier.dup
    ix = nil
    while self.player.peers.find_by_signifier("#{base}#{ix}")
      ix = ( ix.nil? ? 1 : ix +1 )
      raise RuntimeError, "too many attempts" if ix > 50
    end
    self.signifier = "#{base}#{ix}"
  end
  
  def self.resolver_from_peer_url( peer_url )
    uri_parsed = URI.parse( peer_url )
    key_response = UriLib.get( uri_parsed )
    return false unless key_response.code == '200'

    resolver = Resolver.find_by_public_key(key_response.body)
    signifier, uri_parsed = split_peer_url(uri_parsed)
    resolver = Resolver.new if !resolver
    resolver.update_attributes(:end_point => uri_parsed.to_s, :public_key => key_response.body )
    [signifier, resolver]
  end
  
  def self.split_peer_url(uri_parsed)
    paths = uri_parsed.path.split('/')
    signifier = paths.pop
    signifier = signifier.split(Player::SignifierSep).pop
    uri_parsed.path = paths.join('/')
    [signifier, uri_parsed]
  end
  
end
