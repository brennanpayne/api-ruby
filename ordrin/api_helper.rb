require 'net/http'
require 'json'
require 'digest'
require 'json-schema'
require_relative 'mutate'

module Ordrin
  class APIHelper

    def initialize(api_key, servers)
      @api_key = api_key
      @urls = {}
      if servers==:production
        @urls[:restaurant] = "https://r.ordr.in"
        @urls[:user] = "https://u.ordr.in"
        @urls[:order] = "https://o.ordr.in"
      elsif servers==:test
        @urls[:restaurant] = "https://r-test.ordr.in"
        @urls[:user] = "https://u-test.ordr.in"
        @urls[:order] = "https://o-test.ordr.in"
      else
        raise ArgumentError.new("servers must be set to :production, :test, or :custom")
      end
      dir = File.dirname(__FILE__)
      @ENDPOINT_INFO = JSON.parse!(File.read(File.join(dir, "schemas.json")))
    end

    def call_api(base_url, method, uri, data=nil, login=nil)
      methods = {"GET" => Net::HTTP::Get,
        "POST" => Net::HTTP::Post,
        "PUT" => Net::HTTP::Put,
        "DELETE" => Net::HTTP::Delete}
      method = methods[method]
      uri = ('/'+(arguments.collect {|a| URI.encode a.to_s})*'/')
      full_url = URI.parse(base_url+uri)
      req = method.new(full_url.request_uri)
      if not data.nil?
        req.body = URI.encode_www_form(data)
      end
      if not @api_key.empty?
        req['X-NAAMA-CLIENT-AUTHENTICATION'] = "id=\"#{@api_key}\", version=\"1\""
      end
      if not login.nil?
        hash_code = Digest::SHA256.new.hexdigest("#{login[:password]}#{login[:email]}#{uri}")
        req['X-NAAMA-AUTHENTICATION'] = "username=\"#{login[:email]}\", response=\"#{hash_code}\", version=\"1\""
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

    def call_endpoint(endpoint_group, endpoint_name, url_params, kwargs)
      endpoint_data = @ENDPOINT_INFO[endpoint_group][endpoint_name]
      value_mutators = {};
      endpoint_data["properties"].each do |name, info|
        if info.has_key?("mutator")
          value_mutators[name] = Mutate.method(name.intern)
        else
          value_mutators[name] = Mutate.method(:identity)
        end
      end
      if endpoint_data.has_key?("allOf")
        endpoint_data["allOf"].each do |subschema|
          subschema["oneOf"].each do |option|
            option["properties"].each do |name, info|
              if info.has_key?("mutator")
                value_mutators[name] = Mutate.method(name.intern)
              else
                value_mutators[name] = Mutate.method(:identity)
              end
            end
          end
        end
      end
      if not value_mutators.has_key?("email")
        value_mutators["email"] = Mutate.method(:identity)
      end
      JSON::Validator.validate!(endpoint_data, kwargs)
      arg_dict = {}
      url_params.each do |name|
        arg_dict[name] = URI.encode(value_mutators[name].call(kwargs[name]))
      end

      data = {}
      kwargs.each do |name, value|
        if value_mutators.has_key?(name)
          data[name] = value_mutators[name].call(value)
        end
      end
      data.keep_if do |name, value|
        not (url_params.include?(name) or name == "current_password")
      end
      if data.empty?
        data = nil
      end
      tmpl = endpoint_data["meta"]["uri"].gsub(/\{.+?\}/, '%\0')
      uri = tmpl % arg_dict
      login = nil
      if endpoint_data["meta"]["userAuth"]
        if not (kwargs.has_key?("email") and kwargs.has_key?("current_password"))
          raise ArgumentError.new("Authenticated request requires arguments 'email' and 'current_password'")
        end
        login = {email: kwargs["email"], password: Mutate.sha256(kwargs["curent_password"])}
      end
      call_api(urls[endpoint_group], endpoint_data["meta"]["method"], uri, data, login)
    end
  end
end
