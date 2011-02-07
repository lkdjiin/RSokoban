module RSokoban

	# @since 0.74.1
	module GameFactory
		
		# @param [GamePortable|GameCurses|GameTk] a_class
		# @param [UI] ui associated user interface
		# @param [String] level_set set to start playing with
		def self.create a_class, ui, level_set = 'microban.xsb'
			if GamePortable == a_class
				GamePortable.new(ui, level_set)
			elsif GameCurses == a_class
				GameCurses.new(ui, level_set)
			elsif GameTk == a_class
				GameTk.new(ui, level_set)
			else
				raise ArgumentError
			end
		end
		
	end

end
