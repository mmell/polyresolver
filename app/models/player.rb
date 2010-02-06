class Player < ActiveRecord::Base

#  KeyBits = 2048 # msg bytes 245 # FIXME use this in key gen
  KeyGenDays = 730
  PublicKeyDelimiters = { :begin => '-----BEGIN PUBLIC KEY-----', :end => '-----END PUBLIC KEY-----' }
  
  SignifierSep = '.'
  
# this makes testing harder  attr_protected :public_key, :private_key

  has_many :peers, :dependent => :destroy
  
  has_many :transports, :dependent => :destroy
  
  validates_uniqueness_of :signifier
  validates_presence_of :signifier
  validates_format_of :signifier, :with => /[a-z0-9\-]/

  validates_uniqueness_of :public_key
  validates_length_of :public_key_prefix, :maximum => 256
  validates_length_of :public_key_prefix, :minimum => 255
  
  before_validation_on_create [:generate_keypair, :sync_public_key_prefix, :normalize_signifier]

  def normalize_signifier
    self.signifier = Digest::MD5.hexdigest( public_key ) if self.signifier.blank?
    self.signifier = self.signifier.downcase # not sure what effect this has on non-english strings
  end
  
  def sign(token) # only works with private keys
    private_key = OpenSSL::PKey::RSA.new(self.private_key)
#    raise(RuntimeError, "Only private keys can sign.") unless private_key.private?
    dig = OpenSSL::Digest::SHA1.new
    private_key.sign(dig, token)
  end

  def sync_public_key_prefix
    self.public_key_prefix = self.public_key[0,256].chomp(' ') # mysql drops final space
  end
  
  def generate_keypair
    if self.public_key.nil?
      hsh = Player.generate_keypair
      self.public_key = hsh[:public_key]
      self.private_key = hsh[:private_key]
    end
  end
    
  def peer_from_peer_url( peer_url )
    uri_parsed = URI.parse( peer_url )
    key_response = UriLib.get( uri_parsed )
    return false unless key_response.code == '200'

    signifier, uri_parsed = Player.pop_uri_peer(uri_parsed)
    unused, uri_parsed = Player.pop_uri_path(uri_parsed)
    if resolver = Resolver.find_by_public_key(key_response.body) 
      resolver.update_attributes( :end_point => uri_parsed.to_s ) # note: updating record for ALL players
    else
      resolver = Resolver.create!( :end_point => uri_parsed.to_s, :public_key => key_response.body ) 
    end
    self.peers.build( :signifier => signifier, :resolver => resolver )
  end
  
  def self.pop_uri_path(uri_parsed)
    paths = uri_parsed.path.split('/')
    p = paths.pop
    uri_parsed.path = paths.join('/')
    [p, uri_parsed]
  end
  
  def self.pop_uri_peer(uri_parsed)
    signifier, uri_parsed = pop_uri_path(uri_parsed)
    signifier = signifier.split(Player::SignifierSep).pop
    [signifier, uri_parsed]
  end

  def self.generate_keypair
    tmp_path = "#{RAILS_ROOT}/tmp/#{OpenSSL::Digest::MD5.hexdigest( rand(Time.new.to_f).to_s ).upcase}" 
    #    pri = `openssl genrsa 1024`
    #    pub = `openssl req -new -utf8 -batch -pubkey -x509 -nodes -sha1 -days #{KeyGenDays} -key #{tmp_path}.pri` # pri key needs to be in a file which makes this awkward
    # FIXME there are cleaner ways to get the PEM values
    public_data = `openssl req -new -batch -x509 -pubkey -nodes -days #{KeyGenDays} -keyout #{tmp_path}.pri`
    # public_data contains a certificate request
    ix0 = public_data.index(PublicKeyDelimiters[:begin])
    ix1 = public_data.index(PublicKeyDelimiters[:end]) + 24 # PublicKeyDelimiters[:end].length == 24
    private_key = ''
    File.new( "#{tmp_path}.pri", 'r' ).read(nil, private_key)
    public_key = public_data[ix0, (ix1 - ix0)] 
    `rm #{tmp_path}.pri` # FIXME data on disk, even briefly, is a security hole?
    { :public_key => public_key, :private_key => private_key }
  end

end
