require './normalize'
require 'net/http'
require 'json'
require 'digest'

module Ordrin
  class OrdrinApi

    attr_reader :base_url
    
    def initialize(key, base_url)
      @key = key
      @base_url = normalize(base_url, :url)
    end

    protected

    def call_api(method, arguments, login=nil, data=nil)
      Method = {:get => Net::HTTP::Get,
        :post => Net::HTTP::Post,
        :put => Net::HTTP:Put,
        :delete => Net::HTTP::Delete}[method]
      uri = ('/'+(arguments.collect {|a| URI.encode a})*'/')
      full_url = URI.parse(base_url+uri)
      unless data.nil?
        full_url.encode_www_form(data)
      end
      req = Method.new(full_url.request_uri)
      req['X-NAAMA-CLIENT-AUTHENTICATION'] = "id=\"#{@base_url}\", version=\"1\"" unless key.empty?
      unless login.nil?
        hash_code = Digest::SHA256.new.hexdigest("#{login.password}#{login.email}#{uri}")
        req['X-NAAMA-AUTHENTICATION'] = "username=\"#{login.email}\", response=\"#{hash_code}\", version=\"1\""
      end
      res = Net::HTTP.start(full_url.hostname, full_url.port) {|http| http.request(req)}
      #error if not OK response
      res.value
      result = JSON.parse(res.body)
      if result.has_key?('_error') and result['_error']!=0
        if result.has_key?('text')
          raise ApiError(result['msg'], result['text'])
        else
          raise ApiError(result['msg'])
        end
        result
      end
    end
  end
