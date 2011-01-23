module RSokoban

	# I am mostly the game loop.
	class Game

		# Construct a new game that you can later run.
		# @param [:curses|:portable] ui_as_symbol the user interface for the game
		def initialize ui_as_symbol
			@levelLoader = LevelLoader.new "original.xsb"
			@levelNumber = 1
			case ui_as_symbol
				when :curses
					require "rsokoban/ui/curses_console"
					@ui = UI::CursesConsole.new
				when :portable
					require "rsokoban/ui/console"
					@ui = UI::Console.new
			end
		end
		
		# I am the game loop.
		def run
			player_action = start_level
			loop do
				if player_action.level_number?
					player_action = load_level player_action.action
					next
				elsif player_action.set_name?
					player_action = load_a_new_set player_action.action
					next
				elsif player_action.quit?
					break
				elsif player_action.next?
					player_action = next_level
					next
				elsif player_action.retry?
					player_action = try_again
					next
				elsif player_action.move?
					result = @level.move(player_action.action)
				elsif player_action.undo?
					result = @level.undo
				end
				
				if result.start_with?('WIN')
					player_action = @ui.get_action('WIN', @level.map, result)
				else
					player_action = @ui.get_action('DISPLAY', @level.map, result)
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
			@ui.get_action('START', @level.map, message)
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
			begin
				@level = @levelLoader.level(@levelNumber)
				@ui.get_action('START', @level.map, "Level : #{@level.title}")
			rescue LevelNumberTooHighError
				@ui.get_action('END_OF_SET', ['####'], "No more levels in this set")
			end
		end
		
	end
	
	

end
