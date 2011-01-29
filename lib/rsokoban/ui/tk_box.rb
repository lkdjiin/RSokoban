module RSokoban::UI

	# I am an image of the game who knows how to display itself on an array
	# of TkLabel items.
	# @since 0.73
	class TkBox
		
		# @param [String] file path of image file
		# @param [Array<Array<TkLabel>>] output an array to display myself
		def initialize file, output
			@box = TkPhotoImage.new('file' => file, 'height' => 0, 'width' => 0)
			@output = output
		end
		
		# Display myself at x,y coordinate
		def display_at x, y
			@output[y][x].configure('image' => @box)
		end
	end

end
