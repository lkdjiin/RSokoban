module RSokoban

	# I am the map of a level.
	# @since 0.73
	class Map
		# @param [Array<String>]
		attr_reader :rows
		
		attr_reader :width
	
		# Construct a map from an array of strings.
		# @example very simple maps
		#   map1 = Map.new['###', '#@#', '###']
		#
		#   map2 = Map.new
		#   map2.rows = ['###', '#@#', '###']
		#
		# @param [Array<String>]
		def initialize rows = []
			raise ArgumentError unless rows.instance_of?(Array)
			@rows= rows
			compute_width
		end
		
		def rows=(rows)
			@rows = rows
			compute_width
		end
		
		def height
			@rows.size
		end
		
		def [](num)
			@rows[num]
		end
		
		def each(&block)
			@rows.each(&block)
		end
		
		def ==(obj)
			return false unless obj.kind_of?(Map)
			@rows == obj.rows
		end
		
		private
		
		def compute_width
			@width = 0
			@rows.each {|row| @width = row.size if row.size > @width }
		end
		
	end

end
