lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'addressable', '~> 2.5'
  spec.add_dependency 'buftok', '~> 0.2.0'
  spec.add_dependency 'equalizer', '0.0.11'
  spec.add_dependency 'faraday', '~> 0.11'
  spec.add_dependency 'http', '~> 2.1'
  spec.add_dependency 'http_parser.rb', '~> 0.6.0'
  spec.add_dependency 'memoizable', '~> 0.4.2'
  spec.add_dependency 'naught', '~> 1.1'
  spec.add_dependency 'simple_oauth', '~> 0.3.1'
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.authors = ['Erik Michaels-Ober', 'John Nunemaker', 'Wynn Netherland', 'Steve Richert', 'Steve Agalloco']
  spec.description = 'A Ruby interface to the Twitter API.'
  spec.email = %w(sferik@gmail.com)
  spec.files = %w(.yardopts CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md twitter.gemspec) + Dir['lib/**/*.rb']
  spec.homepage = 'http://sferik.github.com/twitter/'
  spec.licenses = %w(MIT)
  spec.name = 'twitter'
  spec.require_paths = %w(lib)
  spec.required_ruby_version = '>= 2'
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = spec.description
  spec.version = Twitter::Version
end
