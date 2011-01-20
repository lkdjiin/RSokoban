require "rsokoban/moveable"

module RSokoban

	# I am a moveable crate.
	class Crate < Position
		include RSokoban::Moveable
		
		# @param [Fixnum] x la coordonnée x
		# @param [Fixnum] y la coordonnée y
		def initialize x, y
			super(x, y)
		end
	end
	
end
