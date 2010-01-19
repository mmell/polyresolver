class Resolver < ActiveRecord::Base

  validates_uniqueness_of :public_key
  validates_presence_of :public_key

  validates_presence_of :end_point

  validates_length_of :public_key_prefix, :is => 256

  before_validation :sync_public_key_prefix
  
  validate :validate_resolution
  
  def sync_public_key_prefix
    self.public_key_prefix = self.public_key[0,256]
  end
  
  def verify(signed, token)
    OpenSSL::PKey::RSA.new(self.public_key).verify(OpenSSL::Digest::SHA1.new, signed, token)
  end

  def validate_resolution
    errors.add(:end_point, "does not resolve") unless check_resolution
  end
  
  def generate_token
    Digest::MD5.hexdigest( "#{rand( 10000 )}#{Time.now.to_f}" )
  end
  
  def check_resolution
    uri_parsed = URI.parse( self.end_point )
    uri_parsed.path += "/authenticate_end_point"
    token = generate_token
    payload = "token=#{CGI::escape(token)}&public_key=#{CGI::escape(self.public_key)}"
    response = UriLib.post( uri_parsed, payload, {}, false )
    return false unless response.code == '200'
    verify(response.body, token)
  end
  
end
