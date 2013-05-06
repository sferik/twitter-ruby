# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'faraday', ['~> 0.8', '< 0.10']
  spec.add_dependency 'multi_json', '~> 1.0'
  spec.add_dependency 'simple_oauth', '~> 0.2'
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.authors = ["John Nunemaker", "Wynn Netherland", "Erik Michaels-Ober", "Steve Richert", "Steve Agalloco"]
  spec.cert_chain  = ['certs/sferik.pem']
  spec.description = %q{A Ruby interface to the Twitter API.}
  spec.email = ['nunemaker@gmail.com', 'wynn.netherland@gmail.com', 'sferik@gmail.com', 'steve.richert@gmail.com', 'steve.agalloco@gmail.com']
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
