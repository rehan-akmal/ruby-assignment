require_relative 'application'  

cities = ["Copenhagen, Denmark", "Lodz, Poland", "Brussels, Belgium", "Islamabad, Pakistan"]
obj = VisualCrossingApi::Base.new(location: cities.first, elements: 'temp,windspeed')
obj.print_cities_data(cities)
