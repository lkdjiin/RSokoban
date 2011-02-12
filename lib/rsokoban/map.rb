module RSokoban

	# I am the map of a level.
	# I am constructed from an array of strings, taken from an xsb file. I transform
	# this array to equalize the length of all strings and I put a speciam mark in all
	# cells that are outside of the walls.
	#
	# @example the first map from the original levels
	#		level_1 = [
	#		'    #####',
	#		'    #   #',
	#		'    #$  #',
	#		'  ###  $##',
	#		'  #  $ $ #',
	#		'### # ## #   ######',
	#		'#   # ## #####  ..#',
	#		'# $  $          ..#',
	#		'##### ### #@##  ..#',
	#		'    #     #########',
	#		'    #######']
	#
	#		map = Map.new level_1
	#		map.rows =>
	#		[
	#		'oooo#####oooooooooo',
	#		'oooo#   #oooooooooo',
	#		'oooo#$  #oooooooooo',
	#		'oo###  $##ooooooooo',
	#		'oo#  $ $ #ooooooooo',
	#		'### # ## #ooo######',
	#		'#   # ## #####  ..#',
	#		'# $  $          ..#',
	#		'##### ### #@##  ..#',
	#		'oooo#     #########',
	#		'oooo#######oooooooo']
	# @since 0.73
	class Map
		# @param [Array<String>]
		attr_reader :rows
		
		attr_reader :width
	
		# @param [Array<String>]
		def initialize rows = []
			raise ArgumentError unless rows.instance_of?(Array)
			@rows= rows
			transform
		end
		
		def rows=(rows)
			initialize rows
		end
		
		def height
			@rows.size
		end
		
		def [](num)
			@rows[num]
		end
		
		def each(&block)
			@rows.each(&block)
		end
		
		def ==(obj)
			return false unless obj.kind_of?(Map)
			@rows == obj.rows
		end
		
		private
		
		def transform
			compute_width
			mark_outside
		end
		
		def compute_width
			@width = 0
			@rows.each {|row| @width = row.size if row.size > @width }
		end
		
		# Mark the cells of floor which live outside of the walls, and make all rows the same size.
		def mark_outside
			mark_start_and_end_of_rows
			mark_middle_of_rows
		end
		
		def mark_start_and_end_of_rows
			(0...@rows.size).each do |num|
				mark_start_of_the_row num
				mark_end_of_the_row num
			end
		end
		
		def mark_start_of_the_row num
			first_wall = @rows[num].index(WALL)
			@rows[num][0, first_wall] = OUTSIDE * first_wall
		end
		
		def mark_end_of_the_row num
			@rows[num] = @rows[num] + OUTSIDE * (@width - @rows[num].size)
		end
		
		def mark_middle_of_rows
			@rows.each_with_index do |row, y|
				x = 0
				row.each_char do |cell|
					if cell == FLOOR
						@rows[y][x] = OUTSIDE if neighbors_outside?(x, y)
					end
					x += 1
				end
			end
		end
		
		def neighbors_outside? x, y
			neighbors_out_of_map?(y) or (@rows[y-1][x].chr == OUTSIDE) or (@rows[y+1][x].chr == OUTSIDE)
		end
		
		def neighbors_out_of_map? y
			(y < 1) or (y+1 >= @rows.size)
		end
		
	end

end
