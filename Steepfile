# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature "sig"

  library "base64"
  library "cgi"
  library "equalizer"
  library "forwardable"
  library "memoizable"
  library "monitor"
  library "naught"
  library "simple_oauth"
  library "singleton"
  library "time"
  library "uri"

  check "lib"

  configure_code_diagnostics(D::Ruby.strict)
end
