module RSokoban

	# I separate element of the map from the floor/wall.
	# @since 0.74.1
	class LayeredMap
	
		attr_reader :floor, :man, :crates, :storages
		
		def initialize map
			raise ArgumentError unless [Map, Array].include?(map.class)
			@map = map
			@floor = nil
			@man = nil
			@crates = []
			@storages = []
			init_floor
			init_man
			init_crates_and_storages
		end
		
		# Get an instant map of the game.
		# @return [Map] the map, after X turns of game.
		def map_as_array
			@map_array = init_floor
			draw_crates
			draw_storages
			draw_man
			@map_array
		end
		
		# Get the content of box x_coord, y_coord
		# @param [Fixnum] x_coord x coordinate in the map
		# @param [Fixnum] y_coord y coordinate in the map
		# @return [' ' | '#' | '.' | 'o' | '*']
		def what_is_on x_coord, y_coord
			box = (@floor[y_coord][x_coord]).chr
			if box == FLOOR
				storage = Storage.new(x_coord, y_coord)
				crate = Crate.new(x_coord, y_coord)
				if @storages.include?(storage) and @crates.include?(crate)
					box = CRATE_ON_STORAGE 
				elsif @storages.include?(storage)
					box = STORAGE
				elsif @crates.include?(crate)
					box = CRATE
				end
			end
			box
		end
		
		private
		
		# Draw the crates for map output
		def draw_crates
			@crates.each {|crate| @map_array[crate.y][crate.x] = what_is_on(crate.x, crate.y) }
		end
		
		# Draw the storages location for map output
		def draw_storages
			@storages.each {|st| @map_array[st.y][st.x] = what_is_on(st.x, st.y) }
		end
		
		# Draw the man for map output
		def draw_man
			box = what_is_on @man.x, @man.y
			put_man_in_map if box == FLOOR
			put_man_on_storage_in_map if box == STORAGE
		end
		
		def put_man_in_map
			@map_array[@man.y][@man.x] = MAN
		end
		
		def put_man_on_storage_in_map
			@map_array[@man.y][@man.x] = MAN_ON_STORAGE
		end
		
		# Removes all storages locations, all crates and the man, leaving only walls and floor.
		#
		# @return [Array<String>] map with only walls and floor
		def init_floor
			@floor = []
			@map.each {|row| 
				@floor.push row.tr("#{STORAGE}#{CRATE}#{MAN}#{CRATE_ON_STORAGE}", FLOOR)
			}
			@floor
		end
		
		# Find the man's position, at the begining of the level.
		def init_man
			x_coord = y_coord = 0
			@map.each {|row| 
				if row.include?(MAN)
					x_coord = row.index(MAN)
					break
				end
				y_coord += 1
			}
			@man = Man.new x_coord, y_coord
		end
		
		# Find position of crates and storages, at the begining of the level.
		def init_crates_and_storages
			y_coord = 0
			@map.each do |line| 
				count = 0
				line.each_char do |char| 
					@crates.push Crate.new(count, y_coord) if char == CRATE
					@storages.push Storage.new(count, y_coord) if char == STORAGE
					if char == CRATE_ON_STORAGE
						@crates.push Crate.new(count, y_coord)
						@storages.push Storage.new(count, y_coord)
					end
					count += 1
				end
				y_coord += 1
			end
		end
		
	end
	
end
