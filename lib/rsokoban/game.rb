module RSokoban

	# I am mostly the game loop.
	class Game

		# Construct a new game that you can later run. Without argument, the game will use
		# a portable (I hope that) console interface.
		# @param [UI] ui the user interface for the game
		def initialize(ui = UI::Console.new)
			@levelLoader = LevelLoader.new "original.xsb"
			@levelNumber = 1
			@ui = ui
		end
		
		# I am the game loop.
		def run
			action = start_level
			loop do
				if action.is_a?(Fixnum)
					action = load_level action
					next
				elsif action.instance_of?(String)
					# Assuming we recieve a filename of level's set to load
					action = load_a_new_set action
					next
				elsif action == :quit
					break
				elsif action == :next
					action = next_level
					next
				elsif action == :retry
					action = try_again
					next
				elsif [:down, :up, :left, :right].include?(action)
					result = @level.move(action)
				end
				
				if result.start_with?('WIN')
					action = @ui.get_action('WIN', @level.picture, result)
				else
					action = @ui.get_action('DISPLAY', @level.picture, result)
				end
			end
		end
		
		private
	
		# Load and start the next level of the set
		# @return [Object] the user's {action}[Console#get_action]
		def next_level
			@levelNumber += 1
			start_level
		end
		
		# Restart the current level
		# @return [Object] the user's {action}[Console#get_action]
		def try_again
			start_level
		end
		
		# Load a new set of levels and start its first level.
		# @param [String] setname the name of the set (with .xsb extension)
		# @return [Object] the user's {action}[Console#get_action]
		def load_a_new_set setname 
			begin
				@levelLoader = LevelLoader.new setname
				@levelNumber = 1
				@level = @levelLoader.level(@levelNumber)
				message = "Level : #{@level.title}"
			rescue NoFileError
				message = "Error, no such file : #{setname}"
			end
			@ui.get_action('START', @level.picture, message)
		end
		
		# Load a level from the current set.
		# @param [Fixnum] num the number of the set (base 1)
		# @return [Object] the user's {action}[Console#get_action]
		def load_level num
			@levelNumber = num
			start_level
		end
		
		# Start a level, according to some instance members.
		# @return [Object] the user's {action}[Console#get_action]
		def start_level
			@level = @levelLoader.level(@levelNumber)
			@ui.get_action('START', @level.picture, "Level : #{@level.title}")
		end
		
	end
	
	

end
