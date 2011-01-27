# -*- encoding: utf-8 -*-
require File.expand_path('../lib/twitter/version', __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency('bundler', '~> 1.0')
  s.add_development_dependency('json', '~> 1.4')
  s.add_development_dependency('nokogiri', '~> 1.4')
  s.add_development_dependency('maruku', '~> 0.6')
  s.add_development_dependency('rake', '~> 0.8')
  s.add_development_dependency('rspec', '~> 2.4')
  s.add_development_dependency('simplecov', '~> 0.3')
  s.add_development_dependency('webmock', '~> 1.6')
  s.add_development_dependency('yard', '~> 0.6')
  s.add_development_dependency('ZenTest', '~> 4.4')
  s.add_runtime_dependency('hashie', '~> 1.0.0')
  s.add_runtime_dependency('faraday', '~> 0.5.4')
  s.add_runtime_dependency('faraday_middleware', '~> 0.3.1')
  s.add_runtime_dependency('jruby-openssl', '~> 0.7.2') if RUBY_PLATFORM == 'java'
  s.add_runtime_dependency('multi_json', '~> 0.0.5')
  s.add_runtime_dependency('multi_xml', '~> 0.2.0')
  s.add_runtime_dependency('simple_oauth', '~> 0.1.3')
  s.authors = ["John Nunemaker", "Wynn Netherland", "Erik Michaels-Ober", "Steve Richert"]
  s.description = %q{A Ruby wrapper for the Twitter REST and Search APIs}
  s.post_install_message =<<eos
********************************************************************************

  Follow @gem on Twitter for announcements, updates, and news.
  https://twitter.com/gem

  Join the mailing list!
  https://groups.google.com/group/ruby-twitter-gem

  Add your project or organization to the apps wiki!
  https://github.com/jnunemaker/twitter/wiki/apps

********************************************************************************
eos
  s.email = ['nunemaker@gmail.com', 'wynn.netherland@gmail.com', 'sferik@gmail.com', 'steve.richert@gmail.com']
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/jnunemaker/twitter'
  s.name = 'twitter'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = s.name
  s.summary = %q{Ruby wrapper for the Twitter API}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Twitter::VERSION.dup
end
