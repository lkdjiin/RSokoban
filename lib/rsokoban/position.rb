module RSokoban

	# I represent an x,y coordinate.
	class Position
		attr_reader :x, :y
		
		# Coordinates must be Fixnum
		def initialize x = 0, y = 0
			@x = x
			@y = y
		end
		
		def ==(obj)
			return false unless obj.kind_of?(Position)
			@x == obj.x and @y == obj.y
		end
		
		def eql?(obj)
			self == obj
		end
		
	end

end
