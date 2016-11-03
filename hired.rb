require 'geokit'
require 'yaml'
require 'byebug'
require 'ruby-progressbar'

cities = YAML.load_file('cities.yaml')['cities']
API_KEY = 'AIzaSyDG0q5LNcKR189qBWXyjW9CeaYXNOA2Vtg'


progressbar = ProgressBar.create


city_pair_permutations = (1 .. cities.length).to_a.inject(0, :+)
PROGRESS_STEP = 100.0 / city_pair_permutations



puts PROGRESS_STEP


Geokit::Geocoders::GoogleGeocoder.api_key = API_KEY

cities_hash = Hash.new {|hash, key| hash[key] = key }


(0...cities.length - 1).each do |idx|

	# cities_left = (1 .. (16 - idx)).to_a.inject(0, :+)
	# puts "#{cities_left} cities left to measure."

	(idx + 1...cities.length).each do |jdx|
		progressbar.progress += PROGRESS_STEP
		from_city, to_city = cities[idx], cities[jdx]
		from_geo_info = Geokit::Geocoders::GoogleGeocoder.geocode from_city
		to_geo_info = Geokit::Geocoders::GoogleGeocoder.geocode to_city
		distance = from_geo_info.distance_to(to_geo_info)
		cities_hash[[from_city, to_city]] = distance

	end

end



# File.open("city_distances.yaml", "w") do |file|
# 	file.write cities_hash.to_yaml
# end

shortest_distance = cities_hash.values.sort.first

shortest_city_pair = cities_hash.keys.select {|city_pair| cities_hash[city_pair] == shortest_distance}.first

first_city, second_city = shortest_city_pair[0], shortest_city_pair[1]

puts "Shortest distance between any two Hired locations is between #{first_city} and #{second_city} - #{shortest_distance.to_i} miles!"
