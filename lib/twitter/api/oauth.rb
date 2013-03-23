require 'twitter/api/utils'

module Twitter
  module API
    module OAuth
    	include Twitter::API::Utils


    	# Allows a registered application to obtain an OAuth 2 Bearer Token, 
    	# which can be used to make API requests on an application's own behalf, 
    	# without a user context. This is called Application-only authentication.
    	# @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    	#
    	# 
      #


      def bearer_token
      	
      end

      def invalidate_token
      end
  
    end
  end
end
