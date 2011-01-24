module RSokoban

	# I am mostly the game loop.
	class Game

		# Construct a new game that you can later run.
		# @param [:curses|:portable|:tk] ui_as_symbol the user interface for the game
		def initialize ui_as_symbol
			@level_loader = LevelLoader.new "original.xsb"
			@level_number = 1
			case ui_as_symbol
				when :curses
					require "rsokoban/ui/curses_console"
					@ui = UI::CursesConsole.new
				when :portable
					require "rsokoban/ui/console"
					@ui = UI::Console.new
				when :tk
					require "rsokoban/ui/tk_ui"
					@ui = UI::TkUI.new
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
				
				move_index = result =~ /\d+/
				if result.start_with?('WIN')
					player_action = @ui.get_action(:type=>:win, :map=>@level.map, :move=>result[move_index..-1])
				else
					if move_index
						player_action = @ui.get_action(:type=>:display, :map=>@level.map, :move=>result[move_index..-1])
					else
						player_action = @ui.get_action(:type=>:display, :map=>@level.map, :error=>result)
					end
				end
			end
		end
		
		private
	
		# Load and start the next level of the set
		# @return [Object] the user's {action}[Console#get_action]
		def next_level
			@level_number += 1
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
			title = nil
			error = nil
			begin
				@level_loader = LevelLoader.new setname
				@level_number = 1
				@level = @level_loader.level(@level_number)
				title = @level.title
			rescue NoFileError
				error = "Error, no such file : #{setname}"
			end
			@ui.get_action(:type=>:start, :map=>@level.map, :title=>title, :error=>error, :set=>@level_loader.set.title,
			:number=>@level_number, :total=>@level_loader.set.size)
		end
		
		# Load a level from the current set.
		# @param [Fixnum] num the number of the set (base 1)
		# @return [Object] the user's {action}[Console#get_action]
		def load_level num
			@level_number = num
			start_level
		end
		
		# Start a level, according to some instance members.
		# @return [Object] the user's {action}[Console#get_action]
		def start_level
			begin
				@level = @level_loader.level(@level_number)
				@ui.get_action(:type=>:start, :map=>@level.map, :title=>@level.title, :set=>@level_loader.set.title,
				:number=>@level_number, :total=>@level_loader.set.size)
			rescue LevelNumberTooHighError
				@ui.get_action(:type=>:end_of_set, :map=>Map.new)
			end
		end
		
	end
	
	

end
