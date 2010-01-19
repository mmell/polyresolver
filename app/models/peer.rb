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
  
  def get_transport(transport_method)
    uri_parsed = URI.parse(self.resolver.end_point + "/transport")
    payload = "transport=#{CGI::escape(transport_method)}&public_key=#{CGI::escape(self.resolver.public_key)}"
    response = UriLib.post( uri_parsed, payload, {}, false )
    (response.code == '200' ? response.body : nil)
  end
  
end
