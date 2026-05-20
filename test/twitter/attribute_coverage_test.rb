require "test_helper"

# Exercises dynamically generated attribute readers and predicate methods so
# they're recorded as covered. Each call to attr_reader / predicate_attr_reader
# defines a new method via `define_method`, which SimpleCov tracks per call
# site, so each reader and predicate must be invoked at least once.
ATTRIBUTE_COVERAGE_CASES = {
  Twitter::Suggestion => {slug: "leaders", name: "Leaders", size: 5},
  Twitter::SavedSearch => {id: 1, query: "twitter", position: 1, name: "twitter"},
  Twitter::Media::Photo => {id: 1, type: "photo", indices: [0, 10]},
  Twitter::Media::Video => {id: 1, type: "video", indices: [0, 10], display_url: "example.com"},
  Twitter::Media::VideoInfo => {duration_millis: 1000, aspect_ratio: [16, 9]},
  Twitter::Variant => {bitrate: 320_000, content_type: "video/mp4"},
  Twitter::Entity::UserMention => {id: 1, screen_name: "sferik", name: "Erik"},
  Twitter::Entity::Symbol => {text: "twitter"},
  Twitter::Entity::Hashtag => {text: "twitter"},
  Twitter::Entity => {indices: [0, 5]},
  Twitter::Tweet => {
    id: 1, text: "hello", source: "web", lang: "en",
    filter_level: "low", in_reply_to_screen_name: "sferik",
    in_reply_to_user_id: 2, in_reply_to_status_id: 3,
    favorite_count: 4, quote_count: 5, reply_count: 6, retweet_count: 7,
    truncated: false, retweeted: false, possibly_sensitive: false,
    favorited: false, current_user_retweet: {id: 8}
  },
  Twitter::Place => {
    id: 1, name: "SF", full_name: "San Francisco",
    country: "United States", attributes: {locality: "SF"}
  },
  Twitter::OEmbed => {
    version: "1.0", type: "rich", provider_name: "Twitter",
    html: "<blockquote></blockquote>", cache_age: "3153600000",
    author_name: "Erik", width: 550, height: 0
  },
  Twitter::Metadata => {result_type: "recent", iso_language_code: "en"},
  Twitter::List => {
    id: 1, name: "Test", mode: "public", full_name: "@user/test",
    description: "A list", subscriber_count: 1, member_count: 1, following: false
  },
  Twitter::Language => {code: "en", name: "English", status: "production"},
  Twitter::Geo => {coordinates: [0.0, 0.0]},
  Twitter::DirectMessage => {id: 1, recipient_id: 1, sender_id: 2, text: "hi"},
  Twitter::User => {
    id: 1, connections: ["following"],
    favourites_count: 0, followers_count: 0, friends_count: 0,
    listed_count: 0, statuses_count: 0, utc_offset: 0,
    description: "Hi", email: "user@example.com", lang: "en",
    location: "SF", name: "Erik",
    profile_background_color: "FFFFFF", profile_link_color: "0000FF",
    profile_sidebar_border_color: "000000", profile_sidebar_fill_color: "EEEEEE",
    profile_text_color: "111111", time_zone: "Pacific Time (US & Canada)",
    contributors_enabled: false, default_profile: false,
    default_profile_image: false, follow_request_sent: false,
    geo_enabled: false, muting: false, needs_phone_verification: false,
    notifications: false, protected: false, profile_background_tile: false,
    profile_use_background_image: false, suspended: false, verified: false,
    profile_background_image_url: "http://example.com/bg.png",
    profile_background_image_url_https: "https://example.com/bg.png"
  },
  Twitter::SourceUser => {
    id: 1, all_replies: false, blocking: false, can_dm: false,
    followed_by: false, marked_spam: false, muting: false,
    notifications_enabled: false, want_retweets: false
  },
  Twitter::TargetUser => {id: 1, followed_by: false},
  Twitter::Size => {h: 100, w: 200, resize: "fit"},
  Twitter::Settings => {
    sleep_time: {enabled: false}, time_zone: {name: "Pacific Time"},
    language: "en", screen_name: "sferik",
    allow_contributor_request: "none", allow_dm_groups_from: "following",
    allow_dms_from: "following", always_use_https: true,
    discoverable_by_email: false, discoverable_by_mobile_phone: false,
    display_sensitive_media: false, geo_enabled: false,
    protected: false, show_all_inline_media: false,
    use_cookie_personalization: false
  },
  Twitter::DirectMessages::WelcomeMessageRule => {id: 1, welcome_message_id: 2},
  Twitter::DirectMessages::WelcomeMessage => {id: 1, name: "Greet", text: "Welcome"},
  Twitter::Trend => {
    name: "#ruby", query: "%23ruby", tweet_volume: 100,
    events: "something", promoted_content: false
  },
  Twitter::Streaming::StallWarning => {
    code: "FALLING_BEHIND", message: "Falling behind", percent_full: 60
  },
  Twitter::Streaming::DeletedTweet => {id: 1, user_id: 2}
}.freeze

describe "attribute method coverage" do
  ATTRIBUTE_COVERAGE_CASES.each do |klass, attrs|
    describe klass do
      let(:object) { klass.new(attrs) }

      attrs.each_key do |attr|
        it "exposes ##{attr}?" do
          assert_includes([true, false], object.public_send(:"#{attr}?"))
        end

        next unless klass.method_defined?(attr) && !klass.method_defined?(:"#{attr}=")

        it "exposes ##{attr}" do
          object.public_send(attr)
        end
      end
    end
  end

  describe Twitter::Identity do
    it "exposes #id?" do
      identity = Twitter::Identity.new(id: 1)

      assert_predicate(identity, :id?)
    end
  end

  describe Twitter::DirectMessageEvent do
    let(:attrs) do
      {
        id: "1",
        created_timestamp: "1495502422",
        message_create: {
          sender_id: "1",
          target: {recipient_id: "2"},
          message_data: {text: "hi", entities: {urls: []}}
        }
      }
    end

    it "exposes #direct_message? and #created_timestamp?" do
      event = Twitter::DirectMessageEvent.new(attrs)

      assert_predicate(event, :direct_message?)
      assert_predicate(event, :created_timestamp?)
    end
  end

  describe Twitter::DirectMessages::WelcomeMessageWrapper do
    let(:attrs) do
      {
        id: "1",
        created_timestamp: "1495502422",
        name: "Welcome",
        message_data: {text: "hi", entities: {urls: []}}
      }
    end

    it "exposes #welcome_message and predicates" do
      wrapper = Twitter::DirectMessages::WelcomeMessageWrapper.new(attrs)

      assert_kind_of(Twitter::DirectMessages::WelcomeMessage, wrapper.welcome_message)
      assert_predicate(wrapper, :welcome_message?)
      refute_nil(wrapper.created_timestamp)
      assert_predicate(wrapper, :created_timestamp?)
    end
  end

  describe Twitter::DirectMessages::WelcomeMessageRuleWrapper do
    let(:attrs) do
      {id: "1", created_timestamp: "1495502422", welcome_message_id: "2"}
    end

    it "exposes #welcome_message_rule and predicates" do
      wrapper = Twitter::DirectMessages::WelcomeMessageRuleWrapper.new(attrs)

      assert_kind_of(Twitter::DirectMessages::WelcomeMessageRule, wrapper.welcome_message_rule)
      assert_predicate(wrapper, :welcome_message_rule?)
      refute_nil(wrapper.created_timestamp)
      assert_predicate(wrapper, :created_timestamp?)
    end
  end

  describe "anonymous Base subclass" do
    it "exposes object_attr_reader predicates" do
      klass = Class.new(Twitter::Base) do
        object_attr_reader :User, :user
      end
      object = klass.new(user: {id: 1})

      assert_predicate(object, :user?)
    end
  end

  describe Twitter::User do
    it "exposes #translator? for is_translator key" do
      assert_predicate(Twitter::User.new(id: 1, is_translator: true), :translator?)
    end

    it "exposes #translation_enabled? for is_translation_enabled key" do
      assert_predicate(Twitter::User.new(id: 1, is_translation_enabled: true), :translation_enabled?)
    end
  end
end
