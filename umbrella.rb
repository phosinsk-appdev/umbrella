p "==================================================================="
p "Can I charge you $20 for an umbrella in RollerCoaster Tycoon today?"
p "==================================================================="

p "Where are you located?"

user_location = gets.chomp

# user_location = "Memphis"

p "Checking the weather at #{user_location}...."

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("GMAPS_KEY")}"

require "open-uri"
raw_gmaps_response = URI.open(gmaps_url).read

require "json"
ruby_gmaps_response = JSON.parse(raw_gmaps_response)

results_array = ruby_gmaps_response.fetch("results")

first_result = results_array.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

p "Your coordinates are #{latitude}, #{longitude}."

# assemble the correct Pirate Weather URL 

pirate_weather_url = "https://api.pirateweather.net/forecast/#{ENV.fetch("PIRATE_WEATHER_KEY")}/#{latitude},#{longitude}"

raw_pirate_weather_response = URI.open(pirate_weather_url).read
ruby_pirate_weather_response = JSON.parse(raw_pirate_weather_response)

get_temp1 = ruby_pirate_weather_response.fetch("currently")
temp = get_temp1.fetch("temperature") 

p "It is currently #{temp}°F"

get_next_hour1 = ruby_pirate_weather_response.fetch("hourly")

next_hour = get_next_hour1.fetch("summary")

p "Next hour: #{next_hour}"

get_hourly1 = ruby_pirate_weather_response.fetch("hourly")
get_hourly2 = get_hourly1.fetch("data")

prec_prob_hash_array = get_hourly2[0...12]

precip_probs = Array.new

prec_prob_hash_array.each do |data_hash|
  hourly_entry = data_hash.fetch("precipProbability")
  precip_probs.push(hourly_entry)
  
  if hourly_entry > 0.1
    p "In #{precip_probs.length} hours, there is a #{(hourly_entry*100).to_i}% chance of precipitation."
  end

end

if precip_probs.max > 0
  p "I hope you brought your wallet! You've got to pay if you want to stay dry in my park!"
else 
  p "Looks like it will be dry today. You're still going to have to pay to use the bathroom..."
end
