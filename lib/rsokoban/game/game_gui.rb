module RSokoban

	# I extends/implements the API of module Game, to run the game
	# within a GUI. I don't define the user interface, you can use me
	# to run game with Tk, Gnome, etc.
	# @since 0.74.1
	module GameGUI
		include Game
		
		attr_writer :ui
		
		def initialize ui, setname = 'microban.xsb'
			super(ui, setname)
		end
		
		def run
			@ui.run
		end
		
		# @todo check if it's important to return the level
		def start_level
			@level = @level_loader.level(@level_number)
		end
		
	end

end
