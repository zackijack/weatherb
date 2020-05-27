# frozen_string_literal: true

require 'faraday'

module FaradayMiddleware
  class RaiseError < Faraday::Middleware
    CLIENT_ERROR_STATUSES = (400...500).freeze
    SERVER_ERROR_STATUSES = (500...600).freeze

    def call(env)
      @app.call(env).on_complete do |response|
        case response[:status].to_i
        when 400
          raise Weatherb::BadRequest, error_message(response)
        when 401
          raise Weatherb::Unauthorized, error_message(response)
        when 403
          raise Weatherb::Forbidden, error_message(response)
        when 429
          raise Weatherb::TooManyRequests, error_message(response)
        when 500
          raise Weatherb::InternalServerError, error_message(response)
        when CLIENT_ERROR_STATUSES
          raise Weatherb::ClientError, error_message(response)
        when SERVER_ERROR_STATUSES
          raise Weatherb::ServerError, error_message(response)
        when nil
          raise Weatherb::NilStatusError, error_message(response)
        end
      end
    end

    private

    def error_message(response)
      "status: #{response[:status]}, message: #{error_body(response[:body])}"
    end

    def error_body(body)
      body = ::JSON.parse(body) if !body.nil? && !body.empty? && body.is_a?(String)

      body['message'].gsub("\n", '')
    end
  end
end
