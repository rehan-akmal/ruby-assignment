module VisualCrossingApi
    class Base
        TIMELINE = 'last30days'
        UNIT_GROUP = 'us'
        INCLUDE = 'days'

        attr_accessor :elements, :base_url, :location
        def initialize(elements:, location:)
            @elements = elements
            @base_url = ENV['BASE_URL']
            @location = location
        end

        def endpoint
            "#{base_url}timeline/#{location.gsub(' ', '')}/#{TIMELINE}/?unitGroup=#{UNIT_GROUP}&key=#{ENV['API_KEY']}&include=#{INCLUDE}&elements=#{elements}"
        end

        def fetch_weather_data
            uri = URI(endpoint)
            Net::HTTP.get(uri)
            JSON.parse(Net::HTTP.get(uri))['days']
        end

        def temperature_data
            fetch_weather_data.map do |obj|
                obj['temp']
            end
        end

        def wind_data
            fetch_weather_data.map do |obj|
                obj['windspeed']
            end
        end

        def median(type = nil)
            data = get_relevant_data(type)
            sorted = data.sort
            mid = (sorted.length - 1) / 2.0
            (sorted[mid.floor] + sorted[mid.ceil]) / 2.0
        end

        def mean(type = nil)
            data = get_relevant_data(type)
            (data.reduce(:+)/data.size.to_f).round(2)  
        end

        def get_relevant_data(type)
            if type == 'wind'
                wind_data
            else
                temperature_data
            end
        end
        def temperature_median
           median('temperature')
        end

        def wind_median
            median('wind')
        end

        def temperature_mean
            mean('temperature')
        end

        def wind_mean
            mean('wind')
        end

        def print_cities_data(cities)
            puts "city\t\t\t\twind_avg\twind_median\t\ttemp_avg\ttmp_median"
            cities.each do |city|
                location = city
                puts "#{city}\t\t\t\t#{wind_mean}\t#{wind_median}\t\t#{temperature_mean}\t#{temperature_median}"
            end
        end
    end
end