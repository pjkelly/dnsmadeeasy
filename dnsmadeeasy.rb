# http://www.dnsmadeeasy.com/enterprisedns/api.html

require 'yaml'
require 'time'
require 'openssl'
require 'httparty'

class DnsMadeEasy
  def self.request_headers
    config = YAML.load_file('config.yml')
    request_date = Time.now.httpdate
    hmac = OpenSSL::HMAC.hexdigest('sha1', config['api_secret'], request_date)
    {
      'Accept' => 'application/json',
      'x-dnsme-apiKey' => config['api_key'],
      'x-dnsme-requestDate' => request_date,
      'x-dnsme-hmac' => hmac
    }
  end

  include HTTParty
  headers request_headers
  base_uri 'api.dnsmadeeasy.com/V1.2'

  def domains
    self.class.get('/domains')
  end

  def domain(domain_name)
    self.class.get("/domains/#{domain_name}")
  end

  def records_for(domain_name)
    self.class.get("/domains/#{domain_name}/records")
  end
end
