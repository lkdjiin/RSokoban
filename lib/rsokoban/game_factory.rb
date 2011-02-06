module RSokoban

	# or module ?
	# @since 0.74.1
	class GameFactory
		private_class_method :new
		
		def self.create a_class
			if GamePortable == a_class
				require "rsokoban/ui/console"
				GamePortable.new
			elsif GameCurses == a_class
				require "rsokoban/ui/curses_console"
				GameCurses.new
			elsif GameTk == a_class
				require "rsokoban/ui/tk_ui"
				require "rsokoban/ui/tk_box"
				require "rsokoban/ui/tk_dialogs"
				GameTk.new
			else
				raise ArgumentError
			end
		end
		
	end

end
