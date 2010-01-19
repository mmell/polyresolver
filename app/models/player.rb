class Player < ActiveRecord::Base

#  KeyBits = 2048 # msg bytes 245 # FIXME use this in key gen
  KeyGenDays = 730
  PublicKeyDelimiters = { :begin => '-----BEGIN PUBLIC KEY-----', :end => '-----END PUBLIC KEY-----' }
  
  SignifierSep = '.'
  
# this makes testing harder  attr_protected :public_key, :private_key
  
  belongs_to :community, :class_name => "Player"

  has_many :members, :dependent => :destroy, :class_name => "Player", :foreign_key => :community_id
  has_many :peers, :dependent => :destroy
  
  has_many :transports, :dependent => :destroy
  
  validates_associated :community # allows nil

  validates_presence_of :signifier
  validates_uniqueness_of :signifier, :scope => :community_id
  validates_format_of :signifier, :with => /[a-z\-]/
  validates_length_of :public_key_prefix, :maximum => 256
  validates_length_of :public_key_prefix, :minimum => 255
  
  before_validation_on_create [:generate_keypair, :sync_public_key_prefix, :downcase_signifier]

  def downcase_signifier
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
#    raise StandardError, self.inspect if self.public_key.nil?
    if self.public_key.nil?
      hsh = Player.generate_keypair
      self.public_key = hsh[:public_key]
      self.private_key = hsh[:private_key]
    end
  end
  
  def community_chain( chain = [] )
    chain << self.signifier
    if self.community_id?
      self.community.community_chain(chain)
    end
    chain
  end
  
  def community_signifier
    self.community_chain.join(SignifierSep)
  end
  
  def self.find_by_signifier(s)
    parent_community_id, player = nil, nil
    s.split(SignifierSep).reverse.each { |e|
      if parent_community_id
        player = Player.find(:first, :conditions => ["signifier = ? and community_id = #{parent_community_id}", e])
      else
        player = Player.find(:first, :conditions => ["signifier = ?", e])
      end
      return nil unless player
      parent_community_id = player.id
    }
    player
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
