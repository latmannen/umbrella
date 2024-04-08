require "http"
require "json"


line_width = 40
#initial text and prompt
puts "=" * line_width
puts "Will you need an umbrella today?".center(line_width)
puts "=" * line_width
puts
puts "Where are you?"
user_location = gets.chomp
# user_location = "Saint Paul"
puts "Checking the weather at #{user_location}...."


#keys
gmaps_key = ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

#getting location from google maps api
raw_gmaps_data = HTTP.get(gmaps_url)
gmaps_parse = JSON.parse(raw_gmaps_data)
results_array = gmaps_parse.fetch("results")
first_result_hash = results_array[0]
geometry_array = first_result_hash.fetch("geometry").fetch("location")
lat = geometry_array.fetch("lat").to_s
lng = geometry_array.fetch("lng").to_s

#string of location for pirate API
location_string = "/#{lat},#{lng}"

puts "Your coordinates are #{lat}, #{lng}."

#pirate
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{lng}"

raw_weather = HTTP.get(pirate_weather_url)

parsed_weather = JSON.parse(raw_weather)

currently_hash = parsed_weather.fetch("currently")

current_temp = currently_hash.fetch("temperature")

puts "It is currently #{current_temp}°F."

# Some locations around the world do not come with minutely data.
minutely_hash = parsed_weather.fetch("minutely", false)

if minutely_hash
  next_hour_summary = minutely_hash.fetch("summary")

  puts "Next hour: #{next_hour_summary}"
end

#hourly information
hourly_hash = parsed_weather.fetch("hourly")

hourly_data_array = hourly_hash.fetch("data")


pp pirate_weather_url
