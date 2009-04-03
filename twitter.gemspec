# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{twitter}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker"]
  s.date = %q{2009-04-03}
  s.email = %q{nunemaker@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["History", "License", "Notes", "Rakefile", "README.rdoc", "VERSION.yml", "examples/connect.rb", "examples/helpers", "examples/helpers/config_store.rb", "examples/search.rb", "examples/timeline.rb", "examples/update.rb", "lib/twitter", "lib/twitter/base.rb", "lib/twitter/oauth.rb", "lib/twitter/request.rb", "lib/twitter/search.rb", "lib/twitter.rb", "test/fixtures", "test/fixtures/firehose.json", "test/fixtures/friends_timeline.json", "test/fixtures/rate_limit_exceeded.json", "test/fixtures/replies.json", "test/fixtures/search.json", "test/fixtures/search_from_jnunemaker.json", "test/fixtures/status.json", "test/fixtures/user_timeline.json", "test/test_helper.rb", "test/twitter", "test/twitter/base_test.rb", "test/twitter/oauth_test.rb", "test/twitter/request_test.rb", "test/twitter/search_test.rb", "test/twitter_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jnunemaker/twitter}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{twitter}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{wrapper for the twitter api (oauth only)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oauth>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.4.2"])
    else
      s.add_dependency(%q<oauth>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0.4.2"])
    end
  else
    s.add_dependency(%q<oauth>, [">= 0"])
    s.add_dependency(%q<httparty>, [">= 0.4.2"])
  end
end
