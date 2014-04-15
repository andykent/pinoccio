Gem::Specification.new do |gem|
  gem.authors       = ["Andy Kent"]
  gem.email         = ["andy.kent@me.com"]
  gem.description   = %q{This library gives access to the pinoccio REST API to configure and manage Troops & Scouts. It additionally bundles all the built in ScoutScript commands so that you can command your Scouts straight from Ruby.}
  gem.summary       = %q{Pinoccio Ruby API}
  gem.homepage      = "https://github.com/andykent/pinoccio"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pinoccio"
  gem.require_paths = ["lib"]
  gem.version       = '0.1.0'
  gem.add_dependency('faraday', '~> 0.9.0')
end