module RSokoban

	# I am a set of sokoban levels.
	# Level set are found in .xsb files.
	#
	# =xsb file format
	# 
	# Info lines begins with semi-colon (;)
	# Map lines begins with a # (that's a wall !)
	# 
	# 1: First info is title of the set
	# 2: Blank line
	# 3: List of info lines : description
	# 4: Blank line
	# 5: Level map
	# 6: info title of this level
	# 7: List of info lines : blabla about this level
	#
	# From 4 to 7 again for each supplementary level
	class LevelSet
		attr_accessor :title, :description, :rawLevels
		
		def initialize
			@title = 'Unknown set title'
			@description = 'Empty description'
			@rawLevels = []
		end
		
	end
	
end
