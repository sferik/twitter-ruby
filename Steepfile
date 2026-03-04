# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature "sig"
  library "base64"
  library "cgi"
  library "forwardable"
  library "memoizable"
  library "naught"
  library "simple_oauth"
  library "time"
  library "uri"

  check "lib"

  configure_code_diagnostics(D::Ruby.strict)
end
