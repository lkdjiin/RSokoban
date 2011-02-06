module RSokoban

	# I am a set of sokoban levels.
	# Level set are found in .xsb files.
	#
	# = xsb file format
	# 
	# Info lines begins with semi-colon (;)
	# Map lines begins with a # (that's a wall !) preceded by 0, 1 or more spaces.
	# 
	# 1. First info is title of the set
	# 2. Blank line
	# 3. List of info lines : description
	# 4. Blank line
	# 5. Level map
	# 6. info title of this level
	# 7. List of info lines : blabla about this level
	#
	# From 4 to 7 again for each supplementary level
	class LevelSet
	
		# @param [String] title get/set the title of this level set.
		attr_accessor :title
		# @param [String] description get/set the description of this level set.
		attr_accessor :description
		# @param [Array<RawLevel>] raw_levels get/set the raw levels of this set
		attr_accessor :raw_levels
		
		def initialize
			@title = 'Unknown set title'
			@description = 'Empty description'
			@raw_levels = []
		end
		
		def size
			@raw_levels.size
		end
		
	end
	
end
