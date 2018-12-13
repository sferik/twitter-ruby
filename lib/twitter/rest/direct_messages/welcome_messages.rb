require 'twitter/arguments'
require 'twitter/rest/upload_utils'
require 'twitter/rest/utils'
require 'twitter/utils'

module Twitter
  module REST
    module DirectMessages
      module WelcomeMessages
        include Twitter::REST::UploadUtils
        include Twitter::REST::Utils
        include Twitter::Utils

        # Welcome Message

        def create_welcome_message(text, name: nil)
          options = {
                  welcome_message: {
                    message_data: {
                      text: text
                    }
                  }
                }
          options[:welcome_message][:name] = name if name
          response = Twitter::REST::Request.new(self, :json_post, '/1.1/direct_messages/welcome_messages/new.json', options).perform
          response
        end

        def delete_welcome_message(welcome_message_id)
          options = {
                  id: welcome_message_id
                }
          response = Twitter::REST::Request.new(self, :delete, '/1.1/direct_messages/welcome_messages/destroy.json', options).perform
          response
        end

        def update_welcome_message(welcome_message_id, text, name: nil)
          params = {
              id: welcome_message_id
          }
          options = {
                  message_data: {
                    text: text
                  }
                }
          options[:welcome_message][:name] = name if name
          response = Twitter::REST::Request.new(self, :json_put, "/1.1/direct_messages/welcome_messages/update.json", options, params).perform
          response
        end

        def welcome_message_list
          response = Twitter::REST::Request.new(self, :get, '/1.1/direct_messages/welcome_messages/list.json').perform
          response
        end

        # Welcome Message Rule

        def create_welcome_message_rule(welcome_message_id)
          options = {
                  welcome_message_rule: {
                    welcome_message_id: welcome_message_id
                  }
                }
          response = Twitter::REST::Request.new(self, :json_post, '/1.1/direct_messages/welcome_messages/rules/new.json', options).perform
          response
        end

        def delete_welcome_message_rule(welcome_message_rule_id)
          options = {
                  id: welcome_message_rule_id
                }
          response = Twitter::REST::Request.new(self, :delete, '/1.1/direct_messages/welcome_messages/rules/destroy.json', options).perform
          response
        end

        def welcome_message_rule_list
          response = Twitter::REST::Request.new(self, :get, '/1.1/direct_messages/welcome_messages/rules/list.json').perform
          response
        end
      end
    end
  end
end
