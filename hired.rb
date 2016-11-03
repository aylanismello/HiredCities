require 'geokit'
require 'yaml'
require 'ruby-progressbar'

CONFIG = YAML.load_file('config.yaml')
CITIES, API_KEY = CONFIG['cities'], CONFIG['api_key']
PROGRESS_STEP = 100 / CITIES.length

class Hired

	def initialize
		Geokit::Geocoders::GoogleGeocoder.api_key = API_KEY
		@progressbar = ProgressBar.create
		@cities_hash = Hash.new {|hash, key| hash[key] = key }
	end

	def start
		city_geocodes = create_city_geocodes
		find_all_distances(city_geocodes)
		find_shortest_distance
	end


	# Initially query all cities and store geocode object in hash
	# to avoid multiple calls to the Maps API
	def create_city_geocodes
		city_geocodes = Hash.new

		CITIES.each do |city|
			city_geocodes[city] = Geokit::Geocoders::GoogleGeocoder.geocode city
			@progressbar.progress += PROGRESS_STEP
		end

		city_geocodes
	end

	# Iterate over all cities, computes all possible distances and
	# stores in @cities_hash E.G. @cities_hash[['LA', 'SF']]  = 350

	def find_all_distances(city_geocodes)

		(0...CITIES.length - 1).each do |idx|
			(idx + 1...CITIES.length).each do |jdx|
				from_city, to_city = CITIES[idx], CITIES[jdx]

				from_geo_info = city_geocodes[from_city]
				to_geo_info = city_geocodes[to_city]

				distance = from_geo_info.distance_to(to_geo_info)
				@cities_hash[[from_city, to_city]] = distance
			end
		end

		@progressbar.progress = 100
	end


	def find_shortest_distance
		shortest_distance = @cities_hash.values.sort.first

		shortest_city_pair = @cities_hash.keys.select do |city_pair|
			@cities_hash[city_pair] == shortest_distance
		end

		shortest_city_pair = shortest_city_pair.first
		first_city, second_city = shortest_city_pair[0], shortest_city_pair[1]

		puts "\n#{first_city}, #{second_city}"
	end

end

hired = Hired.new
hired.start
