# The Default Values
List of default values for each API

## realtime

- unit_system: si
- fields:
    - temp
    - feels_like
    - humidity
    - wind_speed
    - wind_direction
    - baro_pressure
    - precipitation
    - sunrise
    - sunset
    - visibility
    - weather_code
    - dewpoint
    - wind_gust
    - precipitation_type
    - cloud_cover
    - cloud_base
    - cloud_ceiling
    - surface_shortwave_radiation
    - moon_phase

## nowcast

- unit_system: si
- timestep: 1
- start_time: now
- end_time: nil
- fields:
    - temp
    - feels_like
    - humidity
    - wind_speed
    - wind_direction
    - baro_pressure
    - precipitation
    - sunrise
    - sunset
    - visibility
    - weather_code
    - dewpoint
    - wind_gust
    - precipitation_type
    - cloud_cover
    - cloud_base
    - cloud_ceiling
    - surface_shortwave_radiation

## hourly

- unit_system: si
- start_time: now
- end_time: nil
- fields:
    - temp
    - feels_like
    - humidity
    - wind_speed
    - wind_direction
    - baro_pressure
    - precipitation
    - sunrise
    - sunset
    - visibility
    - weather_code
    - dewpoint
    - wind_gust
    - precipitation_type
    - precipitation_probability
    - cloud_cover
    - cloud_base
    - cloud_ceiling
    - surface_shortwave_radiation
    - moon_phase

## daily

- unit_system: si
- start_time: now
- end_time: nil
- fields:
    - temp
    - feels_like
    - humidity
    - wind_speed
    - wind_direction
    - baro_pressure
    - precipitation
    - sunrise
    - sunset
    - visibility
    - weather_code
    - precipitation_probability
    - precipitation_accumulation
