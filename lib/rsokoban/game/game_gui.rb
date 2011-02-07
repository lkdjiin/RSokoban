module RSokoban

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
		
		def start_level
			@level = @level_loader.level(@level_number)
		end
		
	end

end
