# frozen_string_literal: true

module Weatherb
  # Custom error class for rescuing from all Weatherb errors
  class Error < StandardError; end

  # Raised when ClimaCell returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when ClimaCell returns the HTTP status code 401
  class Unauthorized < Error; end

  # Raised when ClimaCell returns the HTTP status code 403
  class Forbidden < Error; end

  # Raised when ClimaCell returns the HTTP status code 429
  class TooManyRequests < Error; end

  # Raised when ClimaCell returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when ClimaCell returns the HTTP status code 4xx
  class ClientError < Error; end

  # Raised when ClimaCell returns the HTTP status code 5xx
  class ServerError < Error; end

  # Raised when ClimaCell returns the HTTP status code is nil
  class NilStatusError < Error; end
end
