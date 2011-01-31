module RSokoban

	# I manage the game.
	class Game
		# @return [Fixnum]
		# @since 0.74
		attr_reader :level_number

		# Construct a new game that you can later run.
		# @param [:curses|:portable|:tk] ui_as_symbol the user interface for the game
		# @param [String] setname only used during testing
		def initialize ui_as_symbol, setname = 'microban.xsb'
			@ui_as_symbol = ui_as_symbol
			@level_loader = LevelLoader.new setname
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
					require "rsokoban/ui/tk_box"
					require "rsokoban/ui/tk_dialogs"
					@gui = UI::TkUI.new self
			end
		end
		
		# Start the game loop.
		#
		# For GUI game (like Tk), the tool kit provide its own event-loop. In that case, I simply
		# call this event-loop via the run() method (for example see {RSokoban::UI::TkUI#run}.
		#
		# For UI game (like Curses) which are text based, Game provide the loop.
		def run
			if [:curses, :portable].include?(@ui_as_symbol)
				ui_mainloop
			else
				@gui.run
			end
		end
		
		# I am the game loop for UIs.
		def ui_mainloop
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
				
				if result[:status] == :win
					player_action = @ui.get_action(:type=>:win, :map=>@level.map, :move=>result[:move_number])
				elsif result[:status] == :ok
					player_action = @ui.get_action(:type=>:display, :map=>@level.map, :move=>result[:move_number])
				else
					player_action = @ui.get_action(:type=>:display, :map=>@level.map, :error=>result[:message])
				end
			end
			true
		end
		
		# @return [Fixnum]
		# @since 0.74
		# @see Level#width
		def level_width
			@level.width
		end
		
		# @return [Fixnum]
		# @since 0.74
		# @see Level#height
		def level_height
			@level.height
		end
		
		# @return [String]
		# @since 0.74
		# @see Level#title
		def level_title
			@level.title
		end
		
		# Get current map of the game
		# @return [Map]
		# @since 0.74
		def map
			@level.map
		end
		
		# Get x coordinate of the man
		# @return [Fixnum]
		# @since 0.74
		def man_x
			@level.man.x
		end
		
		# Get y coordinate of the man
		# @return [Fixnum]
		# @since 0.74
		def man_y
			@level.man.y
		end
		
		# Get result of the move
		# @param [:up|:down|:right|:left] direction
		# @return [Object]
		# @since 0.74
		def move direction
			@level.move direction
		end
		
		# Get current move number
		# @return [Fixnum]
		# @since 0.74
		def move_number
			@level.move_number
		end
		
		# Get result of undo last move
		# @return [MoveResult]
		# @since 0.74
		def undo
			@level.undo
		end
		
		# Get result of redo last undone move
		# @return [MoveResult]
		# @since 0.74
		def redo
			@level.redo
		end
		
		# Get title of the current set
		# @return [String]
		# @since 0.74
		def set_title
			@level_loader.title
		end
		
		# Get numbers of level from the current set
		# @return [Fixnum]
		# @since 0.74
		def set_size
			@level_loader.size
		end
		
		# Start a level, according to some instance members.
		# @return [PlayerAction|nil] the user's action for console window
		#    interface, or nil for GUI.
		def start_level
			begin
				@level = @level_loader.level(@level_number)
				if @ui
					@ui.get_action(:type=>:start, :map=>@level.map, :title=>@level.title, :set=>@level_loader.title,
										:number=>@level_number, :total=>@level_loader.size)
				end
			rescue LevelNumberTooHighError
				if @ui
					@ui.get_action(:type=>:end_of_set, :map=>Map.new)
				else
					raise LevelNumberTooHighError
				end
			end
		end
	
		# Load and start the next level of the set
		# @return [PlayerAction|nil] the user's action for console window
		#    interface, or nil for GUI.
		def next_level
			@level_number += 1
			start_level
		end
		
		# Load a level from the current set.
		# @param [Fixnum] num the number of the set (base 1)
		# @return [PlayerAction|nil] the user's action for console window
		#    interface, or nil for GUI.
		def load_level num
			@level_number = num
			start_level
		end
		
		# Restart from level 1.
		# @return [PlayerAction|nil] the user's action for console window
		#    interface, or nil for GUI.
		def restart_set
			@level_number = 1
			start_level
		end
		
		# Load a new set of levels and start its first level.
		# @param [String] setname the name of the set (with .xsb extension)
		# @return [PlayerAction|nil] the user's action for console window
		#    interface, or nil for GUI.
		def load_a_new_set setname 
			begin
				@level_loader = LevelLoader.new setname
				@level_number = 1
				@level = @level_loader.level(@level_number)
				title = @level.title
			rescue NoFileError
				error = "Error, no such file : #{setname}"
			end
			if @ui
				@ui.get_action(:type=>:start, :map=>@level.map, :title=>title, :error=>error, :set=>@level_loader.title,
						:number=>@level_number, :total=>@level_loader.size)
			end
		end
		
		private
		
		# Restart the current level
		# @return [Object] the user's {action}[Console#get_action]
		def try_again
			start_level
		end
		
	end
	
end
