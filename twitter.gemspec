lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'buftok', '~> 0.2.0'
  spec.add_dependency 'descendants_tracker', '~> 0.0.1'
  spec.add_dependency 'equalizer', ['~> 0.0.7', '!= 0.0.8']
  spec.add_dependency 'faraday', ['>= 0.8', '< 0.10']
  spec.add_dependency 'http', '~> 0.5.0'
  spec.add_dependency 'http_parser.rb', '~> 0.6.0'
  spec.add_dependency 'json', '~> 1.8'
  spec.add_dependency 'memoizable', '~> 0.2.0'
  spec.add_dependency 'simple_oauth', '~> 0.2.0'
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.authors = ["Erik Michaels-Ober", "John Nunemaker", "Wynn Netherland", "Steve Richert", "Steve Agalloco"]
  spec.cert_chain  = ['certs/sferik.pem']
  spec.description = %q{A Ruby interface to the Twitter API.}
  spec.email = ["sferik@gmail.com"]
  spec.files = %w(.yardopts CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md Rakefile twitter.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("spec/**/*")
  spec.homepage = 'http://sferik.github.com/twitter/'
  spec.licenses = ['MIT']
  spec.name = 'twitter'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = '>= 1.3.5'
  spec.signing_key = File.expand_path("~/.gem/private_key.pem") if $0 =~ /gem\z/
  spec.summary = spec.description
  spec.test_files = Dir.glob("spec/**/*")
  spec.version = Twitter::Version
end
