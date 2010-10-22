require 'test_helper'

class ClientTest < Test::Unit::TestCase
  context Twitter::Client do
    setup do
      @configs = Twitter::Configuration::VALID_OPTIONS_KEYS
    end

    context "with base configuration" do
      setup do
        Twitter.configure do |base|
          @configs.each do |config|
            base.send("#{config}=", config.to_s)
          end
        end
      end

      should "inherit Twitter base configuration" do
        client = Twitter::Client.new

        @configs.each do |config|
          assert_equal config.to_s, client.send(config)
        end
      end

      context "and custom configuration" do
        setup do
          @custom = {:access_key => 'AK', :access_secret => 'AS', :consumer_key => 'CK', :consumer_secret => 'CS'}
        end

        should "be able to override Twitter base configuration" do
          client = Twitter::Client.new(@custom)

          @configs.each do |config|
            expected = @custom.fetch(config, config.to_s)
            assert_equal expected, client.send(config)
          end
        end

        should "allow post-initialization access to configuration" do
          client = Twitter::Client.new

          @custom.each do |config, value|
            client.send("#{config}=", value)
          end

          @configs.each do |config|
            expected = @custom.fetch(config, config.to_s)
            assert_equal expected, client.send(config)
          end
        end
      end

      teardown do
        Twitter.reset
      end
    end
  end
end
