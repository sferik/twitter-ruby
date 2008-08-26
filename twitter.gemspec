Gem::Specification.new do |s|
  s.name = %q{twitter}
  s.version = "0.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker"]
  s.date = %q{2008-08-26}
  s.default_executable = %q{twitter}
  s.description = %q{a command line interface for twitter, also a library which wraps the twitter api}
  s.email = %q{nunemaker@gmail.com}
  s.executables = ["twitter"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/twitter", "config/hoe.rb", "config/requirements.rb", "examples/blocks.rb", "examples/direct_messages.rb", "examples/favorites.rb", "examples/friends_followers.rb", "examples/friendships.rb", "examples/identica_timeline.rb", "examples/location.rb", "examples/posting.rb", "examples/replies.rb", "examples/search.rb", "examples/sent_messages.rb", "examples/timeline.rb", "examples/twitter.rb", "examples/verify_credentials.rb", "lib/twitter.rb", "lib/twitter/base.rb", "lib/twitter/cli.rb", "lib/twitter/cli/config.rb", "lib/twitter/cli/helpers.rb", "lib/twitter/cli/migrations/20080722194500_create_accounts.rb", "lib/twitter/cli/migrations/20080722194508_create_tweets.rb", "lib/twitter/cli/migrations/20080722214605_add_account_id_to_tweets.rb", "lib/twitter/cli/migrations/20080722214606_create_configurations.rb", "lib/twitter/cli/models/account.rb", "lib/twitter/cli/models/configuration.rb", "lib/twitter/cli/models/tweet.rb", "lib/twitter/direct_message.rb", "lib/twitter/easy_class_maker.rb", "lib/twitter/rate_limit_status.rb", "lib/twitter/search.rb", "lib/twitter/status.rb", "lib/twitter/user.rb", "lib/twitter/version.rb", "script/destroy", "script/generate", "script/txt2html", "setup.rb", "spec/base_spec.rb", "spec/cli/helper_spec.rb", "spec/direct_message_spec.rb", "spec/fixtures/followers.xml", "spec/fixtures/friends.xml", "spec/fixtures/friends_for.xml", "spec/fixtures/friends_lite.xml", "spec/fixtures/friends_timeline.xml", "spec/fixtures/public_timeline.xml", "spec/fixtures/rate_limit_status.xml", "spec/fixtures/search_results.json", "spec/fixtures/status.xml", "spec/fixtures/user.xml", "spec/fixtures/user_timeline.xml", "spec/search_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/status_spec.rb", "spec/user_spec.rb", "tasks/deployment.rake", "tasks/environment.rake", "tasks/website.rake", "twitter.gemspec", "website/css/common.css", "website/images/terminal_output.png", "website/index.html"]
  s.has_rdoc = true
  s.homepage = %q{http://twitter.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{twitter}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{a command line interface for twitter, also a library which wraps the twitter api}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.6"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.1"])
      s.add_runtime_dependency(%q<main>, [">= 2.8.2"])
      s.add_runtime_dependency(%q<highline>, [">= 1.4.0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.1"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.1.0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.6"])
      s.add_dependency(%q<activesupport>, [">= 2.1"])
      s.add_dependency(%q<main>, [">= 2.8.2"])
      s.add_dependency(%q<highline>, [">= 1.4.0"])
      s.add_dependency(%q<activerecord>, [">= 2.1"])
      s.add_dependency(%q<httparty>, [">= 0.1.0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.6"])
    s.add_dependency(%q<activesupport>, [">= 2.1"])
    s.add_dependency(%q<main>, [">= 2.8.2"])
    s.add_dependency(%q<highline>, [">= 1.4.0"])
    s.add_dependency(%q<activerecord>, [">= 2.1"])
    s.add_dependency(%q<httparty>, [">= 0.1.0"])
  end
end