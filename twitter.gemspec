Gem::Specification.new do |s|
  s.name = %q{twitter}
  s.version = "0.3.1"
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker"]
  s.date = %q{2008-07-23}
  s.default_executable = %q{twitter}
  s.description = %q{a command line interface for twitter, also a library which wraps the twitter api}
  s.email = %q{nunemaker@gmail.com}
  s.executables = ["twitter"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "TODO.txt", "bin/twitter", "config/hoe.rb", "config/requirements.rb", "examples/blocks.rb", "examples/direct_messages.rb", "examples/favorites.rb", "examples/friends_followers.rb", "examples/friendships.rb", "examples/location.rb", "examples/replies.rb", "examples/sent_messages.rb", "examples/timeline.rb", "examples/twitter.rb", "examples/verify_credentials.rb", "lib/twitter.rb", "lib/twitter/base.rb", "lib/twitter/cli.rb", "lib/twitter/cli/config.rb", "lib/twitter/cli/helpers.rb", "lib/twitter/cli/migrations/20080722194500_create_accounts.rb", "lib/twitter/cli/migrations/20080722194508_create_tweets.rb", "lib/twitter/cli/migrations/20080722214605_add_account_id_to_tweets.rb", "lib/twitter/cli/migrations/20080722214606_create_configurations.rb", "lib/twitter/cli/models/account.rb", "lib/twitter/cli/models/configuration.rb", "lib/twitter/cli/models/tweet.rb", "lib/twitter/direct_message.rb", "lib/twitter/easy_class_maker.rb", "lib/twitter/rate_limit_status.rb", "lib/twitter/status.rb", "lib/twitter/user.rb", "lib/twitter/version.rb", "script/destroy", "script/generate", "script/txt2html", "setup.rb", "spec/base_spec.rb", "spec/cli/helper_spec.rb", "spec/direct_message_spec.rb", "spec/fixtures/followers.xml", "spec/fixtures/friends.xml", "spec/fixtures/friends_for.xml", "spec/fixtures/friends_lite.xml", "spec/fixtures/friends_timeline.xml", "spec/fixtures/public_timeline.xml", "spec/fixtures/rate_limit_status.xml", "spec/fixtures/status.xml", "spec/fixtures/user.xml", "spec/fixtures/user_timeline.xml", "spec/spec.opts", "spec/spec_helper.rb", "spec/status_spec.rb", "spec/user_spec.rb", "tasks/deployment.rake", "tasks/environment.rake", "tasks/website.rake", "twitter.gemspec", "website/css/common.css", "website/index.html"]
  s.has_rdoc = true
  s.homepage = %q{http://twitter.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{twitter}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{a command line interface for twitter, also a library which wraps the twitter api}
  s.add_dependency(%q<hpricot>, [">= 0"])
  s.add_dependency(%q<activesupport>, [">= 0"])
end