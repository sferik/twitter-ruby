require 'twitter/rest/response/parse_json'

module Twitter
  module REST
    module Response
      class ParseErrorJson < Twitter::REST::Response::ParseJson
        def unparsable_status_codes
          super + [200]
        end
      end
    end
  end
end
