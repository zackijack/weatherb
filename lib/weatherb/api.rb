# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/raise_error'
module Weatherb
  # API object manage the default properties for fulfilling an API request.
  class API
    CLIMACELL_API_URL = 'https://api.climacell.co/v3'

    DEFAULT_FIELDS = %w[
      temp
      feels_like
      humidity
      wind_speed
      wind_direction
      baro_pressure
      precipitation
      sunrise
      sunset
      visibility
      weather_code
    ].freeze

    DEFAULT_REALTIME_FIELDS = %w[
      wind_gust
      precipitation_type
      cloud_cover
      cloud_base
      cloud_ceiling
      surface_shortwave_radiation
      moon_phase
    ].freeze

    SUCCESS_STATUSES = (200..300).freeze

    # Create a new instance of the Weatherb::API using your API key.
    # Also create Faraday connection with ParseJson middleware.
    #
    # @param api_key [String] ClimaCell API key.
    def initialize(api_key)
      @api_key = api_key

      @connection = Faraday.new CLIMACELL_API_URL do |conn|
        conn.response :json, content_type: /\bjson$/

        conn.use FaradayMiddleware::RaiseError

        conn.adapter Faraday.default_adapter
      end
    end

    # Realtime (<= 1min out)
    # The realtime call provides observational data at the present time,
    # down to the minute, for a specific location. Information is available globally,
    # with high-resolution data available for Japan Western Europe, India, and the US.
    #
    # @param lat [Float] Latitude, -59.9 to 59.9.
    # @param lon [Float] Longitude, -180 to 180.
    # @param unit_system [String] Unit system, "si" or "us".
    # @param fields [Array] Selected fields from ClimaCell data layer (such as "precipitation" or "wind_gust").
    #
    # @return [Hash]
    def realtime(lat:, lon:, unit_system: 'si', fields: DEFAULT_FIELDS | DEFAULT_REALTIME_FIELDS)
      path = 'weather/realtime'

      query = {
        apikey: @api_key,
        lat: lat,
        lon: lon,
        unit_system: unit_system,
        fields: fields
      }

      response = @connection.get(path, query)
      response_body(response)
    end

    def response_body(response)
      if SUCCESS_STATUSES.member?(response.status)
        response.body
      else
        { 'status' => response.status, 'body' => response.body }
      end
    end
  end
end
