lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "twitter/version"

Gem::Specification.new do |spec|
  spec.add_dependency "addressable", "~> 2.8"
  spec.add_dependency "base64"
  spec.add_dependency "buftok", "~> 0.3.0"
  spec.add_dependency "equalizer", "~> 0.0.11"
  spec.add_dependency "http", "~> 5.2"
  spec.add_dependency "http-form_data", "~> 2.3"
  spec.add_dependency "llhttp-ffi", "~> 0.5.0"
  spec.add_dependency "memoizable", "~> 0.4.0"
  spec.add_dependency "multipart-post", "~> 2.4"
  spec.add_dependency "naught", "~> 2.0"
  spec.add_dependency "simple_oauth", "~> 0.3.0"
  spec.authors = ["Erik Berlin", "John Nunemaker", "Wynn Netherland", "Steve Richert", "Steve Agalloco"]
  spec.description = "A Ruby interface to the Twitter API."
  spec.email = %w[sferik@gmail.com]
  spec.files = %w[.yardopts CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md twitter.gemspec] + Dir["lib/**/*.rb"]
  spec.homepage = "https://sferik.github.io/twitter/"
  spec.licenses = %w[MIT]

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri" => "https://github.com/sferik/twitter-ruby/issues",
    "changelog_uri" => "https://github.com/sferik/twitter-ruby/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://rubydoc.info/gems/twitter/",
    "funding_uri" => "https://github.com/sponsors/sferik/",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/sferik/twitter-ruby",
  }

  spec.name = "twitter"
  spec.post_install_message = "The `twitter` gem is deprecated and no longer maintained. Use the `x` gem instead."
  spec.require_paths = %w[lib]
  spec.required_ruby_version = ">= 3.2"
  spec.summary = spec.description
  spec.version = Twitter::Version
end
