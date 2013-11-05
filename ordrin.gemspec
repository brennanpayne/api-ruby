# -*- encoding: utf-8 -*-
$:.push File.expand_path("./lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "ordrin"
  s.version = '1.0.0'
  s.date = '2013-02-13'
  s.platform = Gem::Platform::RUBY
  s.authors = ["Ordr.in"]
  s.email = ['hackfood@ordr.in']
  s.homepage = 'https://github.com/ordrin/api-ruby'
  s.summary = "Ordrin API wrapper"
  s.description = "Ordrin API wrapper. Used to simplify making calls to the Ordr.in API in Ruby"
  s.files = ['lib/ordrin.rb', 'lib/ordrin/api_helper.rb', 'lib/ordrin/mutate.rb',
             'lib/ordrin/schemas.json', "lib/ordrin/cacert.pem"]
  s.require_paths = ['lib']
  s.add_runtime_dependency "json-schema", ["= 2.1.3"]
end
