module RSokoban

	# I figure out a level in a very simple format.
	# I have a title and an array of string (named +picture+), representing the map.
	# @todo document and give some examples
	class RawLevel
		attr_accessor :title, :picture
		
		def initialize title = 'Unknown level title', picture = []
			@title = title
			@picture = picture
		end
		
	end

end
