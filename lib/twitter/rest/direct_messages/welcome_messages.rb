require "twitter/arguments"
require "twitter/rest/upload_utils"
require "twitter/rest/utils"
require "twitter/utils"

module Twitter
  module REST
    module DirectMessages
      # Methods for managing welcome messages in direct messages
      module WelcomeMessages
        include Twitter::REST::UploadUtils
        include Twitter::REST::Utils
        include Twitter::Utils

        # Creates a new welcome message
        #
        # @api public
        # @example
        #   client.create_welcome_message("Welcome!", "default")
        # @param text [String] The text of the welcome message
        # @param name [String] Optional name for the welcome message
        # @param options [Hash] A customizable set of options
        # @return [Twitter::DirectMessages::WelcomeMessage]
        def create_welcome_message(text, name = nil, options = {})
          json_options = {
            welcome_message: {
              message_data: {
                text:
              }
            }
          }
          json_options.fetch(:welcome_message)[:name] = name if name # steep:ignore ArgumentTypeMismatch
          welcome_message_wrapper = perform_request_with_object(:json_post, "/1.1/direct_messages/welcome_messages/new.json", options.merge(json_options), Twitter::DirectMessages::WelcomeMessageWrapper)
          welcome_message_wrapper.welcome_message
        end

        # Destroys welcome messages
        #
        # @api public
        # @example
        #   client.destroy_welcome_message(123456789)
        # @param ids [Array<Integer>] IDs of welcome messages to destroy
        # @return [nil]
        def destroy_welcome_message(*ids)
          perform_requests(:delete, "/1.1/direct_messages/welcome_messages/destroy.json", ids)
        end

        # Updates a welcome message
        #
        # @api public
        # @example
        #   client.update_welcome_message(123456789, "New text")
        # @param welcome_message_id [Integer] The ID of the welcome message
        # @param text [String] The new text for the welcome message
        # @param options [Hash] A customizable set of options
        # @return [Twitter::DirectMessages::WelcomeMessage]
        def update_welcome_message(welcome_message_id, text, options = {})
          params = {
            id: welcome_message_id
          }
          json_options = {
            message_data: {
              text:
            }
          }
          welcome_message_wrapper = perform_request_with_object(:json_put, "/1.1/direct_messages/welcome_messages/update.json", options.merge(json_options), Twitter::DirectMessages::WelcomeMessageWrapper, params)
          welcome_message_wrapper.welcome_message
        end

        # Returns a welcome message
        #
        # @api public
        # @example
        #   client.welcome_message(123456789)
        # @param id [Integer] The ID of the welcome message
        # @param options [Hash] A customizable set of options
        # @return [Twitter::DirectMessages::WelcomeMessage]
        def welcome_message(id, options = {})
          options = options.dup
          options[:id] = id
          welcome_message_wrapper = perform_get_with_object("/1.1/direct_messages/welcome_messages/show.json", options, Twitter::DirectMessages::WelcomeMessageWrapper)
          welcome_message_wrapper.welcome_message
        end

        # Returns a list of welcome messages
        #
        # @api public
        # @example
        #   client.welcome_message_list
        # @param options [Hash] A customizable set of options
        # @option options [Integer] :count Number of records to retrieve
        # @return [Array<Twitter::DirectMessages::WelcomeMessage>]
        def welcome_message_list(options = {})
          limit = options.fetch(:count, 20)
          request_options = options.merge(no_default_cursor: true, count: 50, limit:)
          welcome_message_wrappers = perform_get_with_cursor("/1.1/direct_messages/welcome_messages/list.json", request_options, :welcome_messages, Twitter::DirectMessages::WelcomeMessageWrapper)
          welcome_message_wrappers.collect(&:welcome_message)
        end

        # Creates a new welcome message rule
        #
        # @api public
        # @example
        #   client.create_welcome_message_rule(123456789)
        # @param welcome_message_id [Integer] The ID of the welcome message
        # @param options [Hash] A customizable set of options
        # @return [Twitter::DirectMessages::WelcomeMessageRule]
        def create_welcome_message_rule(welcome_message_id, options = {})
          json_options = {
            welcome_message_rule: {
              welcome_message_id:
            }
          }
          rule_wrapper = perform_request_with_object(:json_post, "/1.1/direct_messages/welcome_messages/rules/new.json", options.merge(json_options), Twitter::DirectMessages::WelcomeMessageRuleWrapper)
          rule_wrapper.welcome_message_rule
        end

        # Destroys welcome message rules
        #
        # @api public
        # @example
        #   client.destroy_welcome_message_rule(123456789)
        # @param ids [Array<Integer>] IDs of welcome message rules to destroy
        # @return [nil]
        def destroy_welcome_message_rule(*ids)
          perform_requests(:delete, "/1.1/direct_messages/welcome_messages/rules/destroy.json", ids)
        end

        # Returns a welcome message rule
        #
        # @api public
        # @example
        #   client.welcome_message_rule(123456789)
        # @param id [Integer] The ID of the welcome message rule
        # @param options [Hash] A customizable set of options
        # @return [Twitter::DirectMessages::WelcomeMessageRule]
        def welcome_message_rule(id, options = {})
          options = options.dup
          options[:id] = id
          rule_wrapper = perform_get_with_object("/1.1/direct_messages/welcome_messages/rules/show.json", options, Twitter::DirectMessages::WelcomeMessageRuleWrapper)
          rule_wrapper.welcome_message_rule
        end

        # Returns a list of welcome message rules
        #
        # @api public
        # @example
        #   client.welcome_message_rule_list
        # @param options [Hash] A customizable set of options
        # @option options [Integer] :count Number of records to retrieve
        # @return [Array<Twitter::DirectMessages::WelcomeMessageRule>]
        def welcome_message_rule_list(options = {})
          limit = options.fetch(:count, 20)
          request_options = options.merge(no_default_cursor: true, count: 50, limit:)
          rule_wrappers = perform_get_with_cursor("/1.1/direct_messages/welcome_messages/rules/list.json", request_options, :welcome_message_rules, Twitter::DirectMessages::WelcomeMessageRuleWrapper)
          rule_wrappers.collect(&:welcome_message_rule)
        end
      end
    end
  end
end
