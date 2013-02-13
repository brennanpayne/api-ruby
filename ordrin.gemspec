# -*- encoding: utf-8 -*-
$:.push File.expand_path("./lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "ordrin"
  s.version = '0.1.3'
  s.date = '2013-01-24'
  s.platform = Gem::Platform::RUBY
  s.authors = ["Ordr.in"]
  s.email = ['hackfood@ordr.in']
  s.homepage = 'https://github.com/ordrin/api-ruby'
  s.summary = "Ordrin API wrapper"
  s.description = "Ordrin API wrapper. Used to simplify making calls to the Ordr.in API in Ruby"

  s.files = ['lib/ordrin.rb', 'lib/ordrin/data.rb', 'lib/ordrin/errors.rb',
             'lib/ordrin/normalize.rb', 'lib/ordrin/order.rb',
             'lib/ordrin/ordrinapi.rb', 'lib/ordrin/restaurant.rb',
             'lib/ordrin/user.rb', 'lib/ordrin/cacert.pem',
             'bin/ordrindemo.rb', 'LICENSE.txt',
             'README.md']
  s.executables = ['ordrindemo.rb']
  s.require_paths = ['lib']
end
