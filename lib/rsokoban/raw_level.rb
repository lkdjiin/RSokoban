module RSokoban

	# I figure out a level in a very simple format.
	# I have a title and a map.
	class RawLevel
		# @return [Map]
		attr_reader :map
		attr_accessor :title
		
		# If map is an array of string, it will be converted to a Map object.
		# @param [String] title
		# @param [Map|Array<String>] map
		def initialize title = 'Unknown level title', map = Map.new
			@title = title
			if map.instance_of?(Map)
				@map = map
			else
				@map = Map.new map
			end
		end
		
		# If val is an array of string, it will be converted to a Map object.
		# @param [Map|Array<String>] val
		def map=(val)
			if val.kind_of?(Map)
				@map = val
			elsif val.kind_of?(Array)
				@map = Map.new val
			else 
				raise ArgumentError
			end
		end
		
	end

end
