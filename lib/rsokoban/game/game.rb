module RSokoban

	# I provide the basic API to run a game.
	# I am user interface agnostic.
	# @since 0.74.1
	module Game
		# @return [Fixnum]
		attr_reader :level_number

		# Construct a new game that you can later run.
		# @param [UI] the user interface associated to this game
		# @param [String] setname The set of levels to begin with
		def initialize ui, setname = 'microban.xsb'
			@level_loader = SetLoader.new setname
			@level_number = 1
			@ui = ui
		end
		
		# Start the game loop.
		# @note You must override me in a concrete class.
		def run
			raise NotImplementedError
		end
		
		# @return [Fixnum]
		def level_width
			@level.width
		end
		
		# @return [Fixnum]
		def level_height
			@level.height
		end
		
		# @return [String]
		def level_title
			@level.title
		end
		
		# Get current map of the game as an array of strings
		# @return [Array<String>]
		def map_as_array
			@level.map_as_array
		end
		
		# Get x coordinate of the man
		# @return [Fixnum]
		def man_x
			@level.man.x
		end
		
		# Get y coordinate of the man
		# @return [Fixnum]
		def man_y
			@level.man.y
		end
		
		# Get result of the move
		# @param [:up|:down|:right|:left] direction
		# @return [Object]
		def move direction
			@level.move direction
		end
		
		# Get current move number
		# @return [Fixnum]
		def move_number
			@level.move_number
		end
		
		# Get result of undo last move
		# @return [MoveResult]
		def undo
			@level.undo
		end
		
		# Get result of redo last undone move
		# @return [MoveResult]
		def redo
			@level.redo
		end
		
		# Get title of the current set
		# @return [String]
		def set_title
			@level_loader.title
		end
		
		# Get numbers of level from the current set
		# @return [Fixnum]
		def set_size
			@level_loader.size
		end
		
		# @note You must override me.
		def start_level
			raise NotImplementedError
		end
	
		# Load and start the next level of the set
		# @return See the implementation of start_level in a descendant module (GameUI or GameGUI).
		def next_level
			@level_number += 1
			start_level
		end
		
		# Load a level from the current set.
		# @param [Fixnum] num the number of the set (base 1)
		# @return See the implementation of start_level in a descendant module (GameUI or GameGUI).
		def load_level num
			@level_number = num
			start_level
		end
		
		# Restart current set from level 1.
		# @return See the implementation of start_level in a descendant module (GameUI or GameGUI).
		def restart_set
			@level_number = 1
			start_level
		end
		
		# Load a new set of levels and start its first level.
		# @param [String] setname the name of the set (with .xsb extension)
		def load_a_new_set setname 
				@level_loader = SetLoader.new setname
				@level_number = 1
				@level = @level_loader.level(@level_number)
		end
		
		# @since 0.76
		def record
			@level.record
		end
		
	end
	
end
