require "rsokoban/moveable"

module RSokoban

	# I am a positionable, moveable crate.
	class Crate < Position
		include RSokoban::Moveable
		
		# Coordinates must be Fixnum
		def initialize x_coord, y_coord
			super(x_coord, y_coord)
		end
	end
	
end
