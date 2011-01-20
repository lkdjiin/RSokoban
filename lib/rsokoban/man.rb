require "rsokoban/moveable"

module RSokoban

	# Je suis le bonhomme qui pousse les caisses...
	class Man < Position
		include RSokoban::Moveable
		
		# @param [Fixnum] x la coordonnée x
		# @param [Fixnum] y la coordonnée y
		def initialize x, y
			super(x, y)
		end
		
	end

end
