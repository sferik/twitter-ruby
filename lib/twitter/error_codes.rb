module Twitter
  #If error code is missing see https://dev.twitter.com/docs/error-codes-responses
  module ErrorCodes
    AUTHENTICATION_PROBLEM       = 32
    RESOURCE_NOT_FOUND           = 34
    SUSPENDED_ACCOUNT            = 64
    DEPRECATED_CALL              = 68
    RATE_LIMIT_EXCEEDED          = 88
    INVALID_OR_EXPIRED_TOKEN     = 89
    OVER_CAPACITY                = 130
    INTERNAL_ERROR               = 131
    OAUTH_TIMESTAMP_OUT_OF_RANGE = 135
    DUPLICATE_STATUS             = 187
    BAD_AUTHENTICATION_DATA      = 215
    LOGIN_VERIFICATION_NEEDED    = 231
  end
end
