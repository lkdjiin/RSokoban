module RSokoban

	# Je suis un emplacement de stockage, c'est à dire un endroit où il faut placer une caisse
	# pour gagner le niveau.
	class Storage < Position
	
		# @param [Fixnum] x la coordonnée x
		# @param [Fixnum] y la coordonnée y
		def initialize x, y
			super(x, y)
		end
	end
	
end
