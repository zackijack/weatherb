# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/raise_error'
module Weatherb
  # API object manage the default properties for fulfilling an API request.
  class API
    API_URL = 'https://api.climacell.co/v3'

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
      dewpoint
      wind_gust
      precipitation_type
      cloud_cover
      cloud_base
      cloud_ceiling
      surface_shortwave_radiation
      moon_phase
    ].freeze

    DEFAULT_NOWCAST_FIELDS = %w[
      dewpoint
      wind_gust
      precipitation_type
      cloud_cover
      cloud_base
      cloud_ceiling
      surface_shortwave_radiation
    ].freeze

    DEFAULT_HOURLY_FIELDS = %w[
      dewpoint
      wind_gust
      precipitation_type
      precipitation_probability
      cloud_cover
      cloud_base
      cloud_ceiling
      surface_shortwave_radiation
      moon_phase
    ].freeze

    DEFAULT_DAILY_FIELDS = %w[
      precipitation_probability
      precipitation_accumulation
    ].freeze

    SUCCESS_STATUSES = (200..300).freeze

    # Create a new instance of the Weatherb::API using your API key.
    # Also create Faraday connection with ParseJson middleware.
    #
    # @param api_key [String] ClimaCell API key.
    def initialize(api_key)
      @api_key = api_key

      @connection = Faraday.new API_URL do |conn|
        conn.response :json, content_type: /\bjson$/

        conn.use FaradayMiddleware::RaiseError

        conn.adapter Faraday.default_adapter
      end
    end

    # Realtime (<= 1min out)
    # The realtime call provides observational data at the present time, down
    # to the minute, for a specific location. Information is available globally,
    # with high-resolution data available for Japan Western Europe, India, and
    # the US.
    #
    # @param lat [Float] Latitude, -59.9 to 59.9.
    # @param lon [Float] Longitude, -180 to 180.
    # @param unit_system [String] Unit system, "si" or "us".
    # @param fields [Array<String>] Selected fields from ClimaCell data layer (such as "precipitation" or "wind_gust").
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

    # Nowcast (<= 360min out)
    # The nowcast call provides forecasting data on a minute-­by-­minute basis,
    # based on ClimaCell’s proprietary sensing technology and models.
    #
    # 6 hours of nowcasting is available for the US. 3 hours of precipitation
    # and 6 hours of non-precipitation data is provided for Japan and Western
    # Europe.
    #
    # @param lat [Float] Latitude, -87 to 89.
    # @param lon [Float] Longitude, -180 to 180.
    # @param unit_system [String] Unit system, "si" or "us".
    # @param timestep [Integer] Time step in minutes, 1-60.
    # @param start_time [String] Start time in ISO 8601 format "2019-03-20T14:09:50Z", or "now".
    # @param end_time [String] End time in ISO 8601 format "2019-03-20T14:09:50Z".
    # @param fields [Array<String>] Selected fields from ClimaCell data layer (such as "precipitation" or "wind_gust").
    #
    # @return [Hash]
    def nowcast(lat:, lon:, unit_system: 'si', timestep: 1, start_time: 'now', end_time: nil, fields: DEFAULT_FIELDS | DEFAULT_NOWCAST_FIELDS)
      path = 'weather/nowcast'

      query = {
        apikey: @api_key,
        lat: lat,
        lon: lon,
        unit_system: unit_system,
        timestep: timestep,
        start_time: start_time,
        end_time: end_time,
        fields: fields
      }

      response = @connection.get(path, query)
      response_body(response)
    end

    # Hourly (<= 96hr out)
    # The hourly call provides a global hourly forecast, up to 96 hours
    # (4 days) out, for a specific location.
    #
    # @param lat [Float] Latitude, -87 to 89.
    # @param lon [Float] Longitude, -180 to 180.
    # @param unit_system [String] Unit system, "si" or "us".
    # @param start_time [String] Start time in ISO 8601 format "2019-03-20T14:09:50Z", or "now".
    # @param end_time [String] End time in ISO 8601 format "2019-03-20T14:09:50Z".
    # @param fields [Array<String>] Selected fields from ClimaCell data layer (such as "precipitation" or "wind_gust").
    #
    # @return [Hash]
    def hourly(lat:, lon:, unit_system: 'si', start_time: 'now', end_time: nil, fields: DEFAULT_FIELDS | DEFAULT_HOURLY_FIELDS)
      path = 'weather/forecast/hourly'

      query = {
        apikey: @api_key,
        lat: lat,
        lon: lon,
        unit_system: unit_system,
        start_time: start_time,
        end_time: end_time,
        fields: fields
      }

      response = @connection.get(path, query)
      response_body(response)
    end

    # Daily (<= 15d out)
    # The daily API call provides a global daily forecast with summaries up to
    # 15 days out.
    #
    # Note
    # Daily results are returned and calculated based on 6am to 6am periods
    # (meteorological timeframe) in UTC (GMT+0). Therefore, requesting forecast
    # for locations with negative GMT offset may provide the first element with
    # yesterday's date.
    #
    # @param lat [Float] Latitude, -87 to 89.
    # @param lon [Float] Longitude, -180 to 180.
    # @param unit_system [String] Unit system, "si" or "us".
    # @param start_time [String] Start time in ISO 8601 format "2019-03-20T14:09:50Z", or "now".
    # @param end_time [String] End time in ISO 8601 format "2019-03-20T14:09:50Z".
    # @param fields [Array<String>] Selected fields from ClimaCell data layer (such as "precipitation" or "wind_gust").
    #
    # @return [Hash]
    def daily(lat:, lon:, unit_system: 'si', start_time: 'now', end_time: nil, fields: DEFAULT_FIELDS | DEFAULT_DAILY_FIELDS)
      path = 'weather/forecast/daily'

      query = {
        apikey: @api_key,
        lat: lat,
        lon: lon,
        unit_system: unit_system,
        start_time: start_time,
        end_time: end_time,
        fields: fields
      }

      response = @connection.get(path, query)
      response_body(response)
    end

    private

    def response_body(response)
      if SUCCESS_STATUSES.member?(response.status)
        response.body
      else
        { 'status' => response.status, 'body' => response.body }
      end
    end
  end
end
