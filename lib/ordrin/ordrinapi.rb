require_relative 'normalize'
require 'net/http'
require 'json'
require 'digest'

module Ordrin
  class OrdrinApi

    attr_reader :base_url
    
    def initialize(key, base_url)
      @key = key
      @base_url = Normalize.normalize(base_url, :url)
    end

    protected

    def call_api(method, arguments, login=nil, data=nil)
      methods = {:get => Net::HTTP::Get,
        :post => Net::HTTP::Post,
        :put => Net::HTTP::Put,
        :delete => Net::HTTP::Delete}
      method = methods[method]
      uri = ('/'+(arguments.collect {|a| URI.encode a.to_s})*'/')
      full_url = URI.parse(base_url+uri)
      req = method.new(full_url.request_uri)
      unless data.nil?
        req.body = URI.encode_www_form(data)
      end
      unless @key.empty?
        req['X-NAAMA-CLIENT-AUTHENTICATION'] = "id=\"#{@key}\", version=\"1\""
      end
      unless login.nil?
        hash_code = Digest::SHA256.new.hexdigest("#{login.password}#{login.email}#{uri}")
        req['X-NAAMA-AUTHENTICATION'] = "username=\"#{login.email}\", response=\"#{hash_code}\", version=\"1\""
      end
      http = Net::HTTP.new(full_url.host, full_url.port)
      if full_url.scheme == "https"
        http.use_ssl = true
        http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end
      res = http.start {|http| http.request(req)}
      #error if not OK response
      res.value
      result = JSON.parse(res.body)
      if result.is_a? Hash
        if result.has_key?('_error') and result['_error']!=0
          if result.has_key?('text')
            raise Errors::ApiError.new(result['msg'], result['text'])
          else
            raise Errors::ApiError.new(result['msg'])
          end
          result
        end
      end
      result
    end
  end
end
