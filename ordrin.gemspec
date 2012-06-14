# -*- encoding: utf-8 -*-
$:.push File.expand_path("./lib", __FILE__)
require 'ordrin/version'

Get::Specification.new do |s|
  s.name = "ordrin"
  s.version = Ordrin::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Ordr.in"]
  s.email = ['tech@ordr.in']
  s.homepage = 'https://github.com/ordrin/api-ruby'
  s.summary = %q{Ordrin API wrapper}
  s.description = %q{Ordrin API wrapper. Used to simplify making calls to the Ordr.in API in Ruby}
  s.add_runtime_dependency "json"

  s.files = Dir.glob("[bin,lib]/**/*")
  s.executables['ordrindemo']
  s.require_paths = ['lib']
end
