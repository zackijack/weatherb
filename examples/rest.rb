# frozen_string_literal: true

require 'geocoder'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/param'
require 'dotenv'
require 'weatherb'

# Sinatra subclass
class REST < Sinatra::Base
  helpers Sinatra::Param
  set :show_exceptions, false
  Dotenv.load

  API_KEY = ENV['CLIMACELL_API_KEY']

  before do
    content_type :json
  end

  get '/:type/:location' do
    param :type, String, in: %w[realtime nowcast hourly daily], transform: :downcase
    param :location, String
    param :unit_system, String, in: %w[si us], transform: :downcase, default: 'si'
    param :fields, Array

    weatherb = Weatherb::API.new(API_KEY)

    geocoding = Geocoder.search(params[:location])
    lat, lon = geocoding.first.coordinates
    address = geocoding.first.address

    puts params[:unit_system]

    result = if params[:fields].nil?
               weatherb.send(
                 params[:type],
                 lat: lat, lon: lon, unit_system: params[:unit_system]
               )
             else
               weatherb.send(
                 params[:type],
                 lat: lat, lon: lon, unit_system: params[:unit_system], fields: params[:fields]
               )
             end

    json [
      address: address,
      result: result
    ]
  end

  error 400...600 do
    content_type :json

    e = env['sinatra.error']
    status e.status_code
    { status: e.status_code, message: e.message }.to_json
  end

  run!
end
