require "rsokoban/moveable"

module RSokoban

	# Je suis le bonhomme qui pousse les caisses...
	class Man < Position
		include RSokoban::Moveable
		
		# Coordinates must be Fixnum
		def initialize x_coord, y_coord
			super(x_coord, y_coord)
		end
		
	end

end
