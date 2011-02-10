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
			transform
		end
		
		def rows=(rows)
			initialize rows
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
		
		def transform
			compute_width
			mark_outside
		end
		
		def compute_width
			@width = 0
			@rows.each {|row| @width = row.size if row.size > @width }
		end
		
		def mark_outside
			(0...@rows.size).each do |row_num|
				first_wall = @rows[row_num].index(WALL)
				@rows[row_num][0, first_wall] = 'o' * first_wall
			end
		end
		
	end

end
