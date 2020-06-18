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
          raise Weatherb::BadRequest.new(error_body(response[:body]), 400)
        when 401
          raise Weatherb::Unauthorized.new(error_body(response[:body]), 401)
        when 403
          raise Weatherb::Forbidden.new(error_body(response[:body]), 403)
        when 429
          raise Weatherb::TooManyRequests.new(error_body(response[:body]), 429)
        when 500
          raise Weatherb::InternalServerError.new(error_body(response[:body]), 500)
        when CLIENT_ERROR_STATUSES
          raise Weatherb::ClientError.new(error_body(response[:body]), 400)
        when SERVER_ERROR_STATUSES
          raise Weatherb::ServerError.new(error_body(response[:body]), 500)
        when nil
          raise Weatherb::NilStatusError.new(error_body(response[:body]), 0)
        end
      end
    end

    private

    def error_body(body)
      body = ::JSON.parse(body) if !body.nil? && !body.empty? && body.is_a?(String)

      body['message'].gsub("\n", '')
    end
  end
end
