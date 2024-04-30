lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "twitter/version"

Gem::Specification.new do |spec|
  spec.add_dependency "addressable", "~> 2.8"
  spec.add_dependency "buftok", "~> 0.3.0"
  spec.add_dependency "equalizer", "~> 0.0.11"
  spec.add_dependency "http", "~> 5.2"
  spec.add_dependency "http-form_data", "~> 2.3"
  spec.add_dependency "llhttp-ffi", "~> 0.5.0"
  spec.add_dependency "memoizable", "~> 0.4.0"
  spec.add_dependency "multipart-post", "~> 2.4"
  spec.add_dependency "naught", "~> 1.1"
  spec.add_dependency "simple_oauth", "~> 0.3.0"
  spec.authors = ["Erik Berlin", "John Nunemaker", "Wynn Netherland", "Steve Richert", "Steve Agalloco"]
  spec.description = "A Ruby interface to the Twitter API."
  spec.email = %w[sferik@gmail.com]
  spec.files = %w[.yardopts CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md twitter.gemspec] + Dir["lib/**/*.rb"]
  spec.homepage = "https://sferik.github.io/twitter/"
  spec.licenses = %w[MIT]
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.name = "twitter"
  spec.post_install_message = "📣 Attention Twitter Ruby Gem User!
If you're seeing this message, that means you're using the old Twitter Ruby gem
which is no longer maintained and will not support Twitter API v2.

🎉 Here's the good news:
We recommend switching to the X gem, which supports both API v1.1 and v2. It's
a robust, modern libary that is designed to ensure you'll be able to easily
integrate forthcoming API changes.

🔗 For more details, visit: https://sferik.github.io/x-ruby/

🤔 Please consider sponsoring
The X gem is free to use, but with new API pricing tiers, it actually costs
money to develop and maintain. By contributing to the project, you help:

1. 🛠  Maintain the library: Keeping it up-to-date and secure.
2. 🌈 Add new features: Enhancements that make your life easier.
3. 💬 Provide support: Faster responses to issues and feature requests.
⭐️ Bonus: Sponsors will get priority influence over the project roadmap.
Your company's logo will also be displayed on the project's GitHub page.

🔗 To sponsor, visit: https://github.com/sponsors/sferik

Building and maintaining an open-source project like this takes a considerable
amount of time and effort. Your sponsorship can help sustain this project. Even
a small monthly donation makes a big difference!

💖 Thanks for considering sponsorship. Together we can make the X gem even better!
"
  spec.require_paths = %w[lib]
  spec.required_ruby_version = ">= 3.1.4"
  spec.summary = spec.description
  spec.version = Twitter::Version
end
