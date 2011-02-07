module RSokoban

	# or module ?
	# @since 0.74.1
	class GameFactory
		private_class_method :new
		
		def self.create a_class, ui, level_set
			if GamePortable == a_class
				require "rsokoban/ui/console"
				GamePortable.new(ui, level_set)
			elsif GameCurses == a_class
				require "rsokoban/ui/curses_console"
				GameCurses.new(ui, level_set)
			elsif GameTk == a_class
				require "rsokoban/ui/tk_ui"
				require "rsokoban/ui/tk_box"
				require "rsokoban/ui/tk_dialogs"
				GameTk.new(ui, level_set)
			else
				raise ArgumentError
			end
		end
		
	end

end
