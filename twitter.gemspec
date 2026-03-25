lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "twitter/version"

Gem::Specification.new do |spec|
  spec.add_dependency "base64", "~> 0.3.0"
  spec.add_dependency "buftok", "~> 1.0"
  spec.add_dependency "equalizer", "~> 1.0"
  spec.add_dependency "http", "~> 6.0"
  spec.add_dependency "memoizable", "~> 0.5.1"
  spec.add_dependency "naught", "~> 2.3"
  spec.add_dependency "simple_oauth", "~> 0.4.0"
  spec.add_dependency "uri", "~> 1.1"
  spec.authors = ["Erik Berlin", "John Nunemaker", "Wynn Netherland", "Steve Richert", "Steve Agalloco"]
  spec.description = "A Ruby interface to the Twitter API."
  spec.email = %w[sferik@gmail.com]
  spec.files = %w[LICENSE.md README.md] + Dir["lib/**/*.rb"]
  spec.homepage = "https://github.com/sferik/twitter-ruby"
  spec.licenses = %w[MIT]

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://rubydoc.info/gems/twitter",
    "funding_uri" => "https://github.com/sponsors/sferik/",
    "homepage_uri" => "https://sferik.github.io/twitter",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => spec.homepage
  }

  spec.name = "twitter"
  spec.require_paths = %w[lib]
  spec.required_ruby_version = ">= 3.3"
  spec.summary = spec.description
  spec.version = Twitter::Version
end
