require 'geokit'
require 'yaml'
require 'ruby-progressbar'

CONFIG = YAML.load_file('config.yaml')
CITIES, API_KEY = CONFIG['cities'], CONFIG['api_key']
CITY_PAIR_PERMUTATIONS = (1 ... CITIES.length).to_a.inject(0, :+)
PROGRESS_STEP = 100.0 / CITY_PAIR_PERMUTATIONS


class Hired

	def initialize
		@progressbar = ProgressBar.create
		Geokit::Geocoders::GoogleGeocoder.api_key = API_KEY
	end

	def init
		iterate_cities
		find_shortest_cities
	end

	def iterate_cities
		@cities_hash = Hash.new {|hash, key| hash[key] = key }

		(0...CITIES.length - 1).each do |idx|
			(idx + 1...CITIES.length).each do |jdx|

				@progressbar.progress += PROGRESS_STEP
				from_city, to_city = CITIES[idx], CITIES[jdx]
				from_geo_info = Geokit::Geocoders::GoogleGeocoder.geocode from_city
				to_geo_info = Geokit::Geocoders::GoogleGeocoder.geocode to_city
				distance = from_geo_info.distance_to(to_geo_info)
				@cities_hash[[from_city, to_city]] = distance
			end
		end

	end

	def find_shortest_cities
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
hired.init
