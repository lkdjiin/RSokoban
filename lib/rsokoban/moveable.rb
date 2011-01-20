module RSokoban

	# Permits to move one box in all 4 directions.
	module Moveable
		def up
			@y -= 1
		end
		
		def down
			@y += 1
		end
		
		def left
			@x -= 1
		end
		
		def right
			@x += 1
		end
	end

end
