# -*- encoding: utf-8 -*-
$:.push File.expand_path("./lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "ordrin"
  s.version = '0.2.0'
  s.date = '2013-02-13'
  s.platform = Gem::Platform::RUBY
  s.authors = ["Ordr.in"]
  s.email = ['hackfood@ordr.in']
  s.homepage = 'https://github.com/ordrin/api-ruby'
  s.summary = "Ordrin API wrapper"
  s.description = "Ordrin API wrapper. Used to simplify making calls to the Ordr.in API in Ruby"
  s.files = ['ordrin/api.rb', 'ordrin/api_helper.rb', 'ordrin/mutate.rb',
             'ordrin/schema.json', "ordrin/cacert.pem"]
  s.executables = ['ordrindemo.rb']
  s.require_paths = ['ordrin']
end
