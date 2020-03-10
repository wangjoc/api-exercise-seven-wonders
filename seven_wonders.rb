require 'httparty'
require 'pry'

### COMPREHENSION QUESTIONS ###
# 1. BASE_URL and LOCATION_IQ_KEY are the constant variables (strings)
# 2. Methods are get_location and find_seven_wonders
# 3. find_seven_wonders returns array of seven_wonder_locations (which is populated by calling get_location in a loop)
# 4a. API Rate Limiter - limit on number of requests, or the quantity of data clients can consume. If too many requests are sent, API rate limiting can throttle client connections instead of disconnecting them immediately.
# 4b. Ruby sleep accepts number of seconds as arguments and suspends thread of execution for the amount of seconds passed as a parameter. 
# 5. Ruby pauses for 0.5 seconds, and then looks for the location of each wonder (calling get_location method), and then takes adds that to the seven_wonders_locations array. 

BASE_URL = "https://us1.locationiq.com/v1/search.php?"
REVERSE_URL = "https://us1.locationiq.com/v1/reverse.php?"
DIRECTION_URL = "https://us1.locationiq.com/v1/directions/driving/"



def get_location(search_term)
  query_parameters = {
    key: LOCATION_IQ_KEY, 
    q: search_term,
    format: 'json'
  }

  response = HTTParty.get(BASE_URL, query: query_parameters)

  return {
    "#{search_term}" => {
      :lat => response[0]["lat"],
      :lon => response[0]["lon"] 
      }
    }
end

def get_place(latitude, longitude)
  query_parameters = {
    key: LOCATION_IQ_KEY, 
    lat: latitude,
    lon: longitude,
    format: 'json'
  }

  response = HTTParty.get(REVERSE_URL, query: query_parameters)

  return response["address"]["neighbourhood"]
end

def find_seven_wonders

  seven_wonders = ["Great Pyramid of Giza", "Gardens of Babylon", "Colossus of Rhodes", "Pharos of Alexandria", "Statue of Zeus at Olympia", "Temple of Artemis", "Mausoleum at Halicarnassus"]

  seven_wonders_locations = []
  
  seven_wonders.each do |wonder|
    sleep(0.5)
    seven_wonders_locations << get_location(wonder)
  end

  return seven_wonders_locations
end

def find_places

  places = [
    {lat: 38.8976998, lon: -77.0365534886228}, 
    {lat: 48.4283182, lon: -123.3649533 }, 
    {lat: 41.8902614, lon: 12.493087103595503}
  ]

  place_names = []

  places.each do |place|
    sleep(0.5)
    place_names << get_place(place[:lat], place[:lon])
  end

  return place_names
end

def get_directions
  query_parameters = { 
    key: "#{LOCATION_IQ_KEY}",
  }

  location_one = get_location("Cairo Egypt")["Cairo Egypt"]
  sleep(0.5)
  location_two = get_location("Great Pyramid of Giza")["Great Pyramid of Giza"]
  sleep(0.5)

  coordinates = location_one[:lat] + "," + location_one[:lon] + ";" + location_two[:lat] + "," + location_two[:lon]

  response = HTTParty.get(DIRECTION_URL + "#{coordinates}", query: query_parameters)

  return response["waypoints"]
end

puts "#{find_seven_wonders}"
puts "#{find_places}"
puts "#{get_directions}"

# Expecting something like:
# [{"Great Pyramid of Giza"=>{:lat=>"29.9791264", :lon=>"31.1342383751015"}}, {"Gardens of Babylon"=>{:lat=>"50.8241215", :lon=>"-0.1506162"}}, {"Colossus of Rhodes"=>{:lat=>"36.3397076", :lon=>"28.2003164"}}, {"Pharos of Alexandria"=>{:lat=>"30.94795585", :lon=>"29.5235626430011"}}, {"Statue of Zeus at Olympia"=>{:lat=>"37.6379088", :lon=>"21.6300063"}}, {"Temple of Artemis"=>{:lat=>"32.2818952", :lon=>"35.8908989553238"}}, {"Mausoleum at Halicarnassus"=>{:lat=>"37.03788265", :lon=>"27.4241455276707"}}]
