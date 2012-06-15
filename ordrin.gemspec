# -*- encoding: utf-8 -*-
$:.push File.expand_path("./lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "ordrin"
  s.version = '0.1.1'
  s.date = '2012-06-14'
  s.platform = Gem::Platform::RUBY
  s.authors = ["Ordr.in"]
  s.email = ['tech@ordr.in']
  s.homepage = 'https://github.com/ordrin/api-ruby'
  s.summary = "Ordrin API wrapper"
  s.description = "Ordrin API wrapper. Used to simplify making calls to the Ordr.in API in Ruby"
  s.add_dependency("json", [">= 1.7.3"])

  s.files = ['lib/ordrin.rb', 'lib/ordrin/data.rb', 'lib/ordrin/errors.rb',
             'lib/ordrin/normalize.rb', 'lib/ordrin/order.rb',
             'lib/ordrin/ordrinapi.rb', 'lib/ordrin/restaurant.rb',
             'lib/ordrin/user.rb', 'bin/ordrindemo.rb', 'LICENSE.txt',
             'README.md']
  s.executables = ['ordrindemo.rb']
  s.require_paths = ['lib']
end
