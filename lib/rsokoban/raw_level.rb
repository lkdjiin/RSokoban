module RSokoban

	# I figure out a level in a very simple format.
	# I have a title and a map.
	# @todo document and give some examples
	class RawLevel
		attr_reader :map
		attr_accessor :title
		
		def initialize title = 'Unknown level title', map = Map.new
			@title = title
			if map.instance_of?(Map)
				@map = map
			else
				@map = Map.new map
			end
		end
		
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
