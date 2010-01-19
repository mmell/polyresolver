require 'net/https'
require 'uri'
require 'rexml/document'
require 'rexml/xpath'

module UriLib

  def self.post(uri_parsed, payload, headers = {}, use_ssl=true, opts = {})
    opts[:time_out] ||= 10
    connect = Net::HTTP.new( uri_parsed.host, uri_parsed.port )
    connect.read_timeout=( opts[:time_out] )
    connect.use_ssl = use_ssl
    connect.post(uri_parsed.path, payload, headers )
  end

  def self.get(uri_parsed, redirect_limit = 0, opts = {})
    opts[:time_out] ||= 10
    uri_parsed.path = '/' if uri_parsed.path.empty?
    uri_parsed.path << ('?' + uri_parsed.query) unless uri_parsed.query.nil?
    site = Net::HTTP.new(uri_parsed.host, uri_parsed.port)
    site.read_timeout=( opts[:time_out] ) 
    site.use_ssl = (uri_parsed.port == 443)? true : false
    response = site.get2(uri_parsed.path)
    if response.code == '200'
      response
    elsif ['301', '302', '303', '305', '307'].include?( response.code)
      raise RuntimeError, 'HTTP redirects exceeded limit' if redirect_limit < 1
      get(response['location'], redirect_limit - 1, opts)
    else
      response.error!
    end
  end

end
