module RSokoban

	# I am a level of the game.
	# To complete a level, place each crate ('$') on a storage location ('.').
	class Level
		attr_reader :floor, :man, :crates, :storages, :title
		
		# Get map width of this level, in cells
		# @return [Fixnum]
		attr_reader :width
		
		# Get map height of this level, in cells
		# @return [Fixnum]
		attr_reader :height
		
		# I build the level from a RawLevel object.
		# @example a RawLevel object
		#   A RawLevel object have got one title and one 'picture'. A 'picture' is an array of string.
		#   Each string contain one line of the level map.
		#	  'Level 1', ['#####', '#.o@#', '#####']
		# 
		# * '#' is a wal
		# * '.' is a storage location
		# * '$' is a crate
		# * '*' is a crate on storage location
		# * '@' is the man
		# * ' ' is an empty floor
		#
		# @param [RawLevel] raw_level
		def initialize raw_level
			@title = raw_level.title
			@width = raw_level.map.width
			@height = raw_level.map.height
			@floor = init_floor raw_level.map
			@man = init_man raw_level.map
			@crates = []
			@storages = []
			init_crates_and_storages raw_level.map
			@move = 0
			@map = nil
			@move_recorder = MoveRecorder.new
		end
		
		# Two Level objects are equals if their @title, @floor, @man, @crates and @storages are equals.
		# @param [Object] obj
		# @return [false|true]
		def ==(obj)
			return false unless obj.kind_of?(Level)
			@floor == obj.floor and @man == obj.man and @crates == obj.crates and @storages == obj.storages and @title == obj.title
		end
		
		# Synonym of #==
		# @see #==
		def eql?(obj)
			self == obj
		end
		
		# Get an instant map of the game.
		# @return [Map] the map, after X turns of game.
		def map_as_array
			@map = init_floor @floor
			draw_crates
			draw_storages
			draw_man
			@map
		end
		
		# Move the man one box +direction+.
		# @param [:up|:down|:right|:left] direction
		# @return [MoveResult] the move's result
		def move direction
			return MoveResult.new(:status => :error, :message => 'wall') if wall?(direction)
			return MoveResult.new(:status => :error, :message => 'wall behind crate') if wall_behind_crate?(direction)
			return MoveResult.new(:status => :error, :message => 'double crate') if double_crate?(direction)
			@move += 1
			@man.send(direction)
			if @crates.include?(Crate.new(@man.x, @man.y))
				idx = @crates.index(Crate.new(@man.x, @man.y))
				@crates[idx].send(direction)
				@move_recorder.record direction, :push
			else
				@move_recorder.record direction
			end
			
			return MoveResult.new(:status => :win, :move_number => @move) if win?
			MoveResult.new(:status => :ok, :move_number => @move)
		end
		
		# Redo the last undo
		# @since 0.74
		def redo
			begin
				case @move_recorder.redo
					when :up, :UP then direction = :up
					when :down, :DOWN then direction = :down
					when :left, :LEFT then direction = :left
					when :right, :RIGHT then direction = :right
				end
				@man.send(direction)
				@move += 1
				if @crates.include?(Crate.new(@man.x, @man.y))
					idx = @crates.index(Crate.new(@man.x, @man.y))
					@crates[idx].send(direction)
				end
			rescue EmptyRedoError
				# Nothing to do
			end
			MoveResult.new(:status => :ok, :move_number => @move)
		end
		
		# Undo last move
		def undo
			begin
				case @move_recorder.undo
					when :up then @man.down
					when :down then @man.up
					when :left then @man.right
					when :right then @man.left
					when :UP
						i = @crates.index(Crate.new(@man.x, @man.y-1))
						@crates[i].down
						@man.down
					when :DOWN
						i = @crates.index(Crate.new(@man.x, @man.y+1))
						@crates[i].up
						@man.up
					when :LEFT
						i = @crates.index(Crate.new(@man.x-1, @man.y))
						@crates[i].right
						@man.right
					when :RIGHT
						i = @crates.index(Crate.new(@man.x+1, @man.y))
						@crates[i].left
						@man.left
				end
				@move -= 1
			rescue EmptyMoveQueueError
				# Nothing to do
			end
			MoveResult.new(:status => :ok, :move_number => @move)
		end
		
		# Get current move number
		# @return [Fixnum]
		# @since 0.74
		def move_number
			@move
		end
		
		private
		
		# @return true if all crates are on a storage location
		def win?
			return false if @crates.size == 0 # needed for testing purpose.
			@crates.each {|crate|
				return false unless @storages.include?(crate)
			}
			true
		end
		
		# Is there a wall near the man, in the direction pointed to by +direction+ ?
		# @param [:up|:down|:left|:right] direction
		# @return [true|false]
		def wall? direction
			case direction
				when :up
					box = what_is_on(@man.x, @man.y-1)
				when :down
					box = what_is_on(@man.x, @man.y+1)
				when :left
					box = what_is_on(@man.x-1, @man.y)
				when :right
					box = what_is_on(@man.x+1, @man.y)
			end
			return(box == WALL)
		end
		
		# Is there a crate followed by a wall near the man, in the direction pointed to by +direction+ ?
		# @param [:up|:down|:left|:right] direction
		# @return [true|false]
		def wall_behind_crate?(direction)
			case direction
				when :up
					near = crate_up?
					box_behind = what_is_on(@man.x, @man.y-2)
				when :down
					near = crate_down?
					box_behind = what_is_on(@man.x, @man.y+2)
				when :left
					near = crate_left?
					box_behind = what_is_on(@man.x-2, @man.y)
				when :right
					near = crate_right?
					box_behind = what_is_on(@man.x+2, @man.y)
			end
			near and box_behind == WALL
		end
		
		# Is there a crate followed by a crate near the man, in the direction pointed to by +direction+ ?
		# @param [:up|:down|:left|:right] direction
		# @return [true|nil]
		def double_crate?(direction)
			case direction
				when :up then crate_up? and crate_two_steps_up?
				when :down then crate_down? and crate_two_steps_down?
				when :left then crate_left? and crate_two_steps_left?
				when :right then crate_right? and crate_two_steps_right?
			end
		end
		
		# Is there a crate ('o' or '*') in the box pointed to by x_coord, y_coord ?
		# @param [Fixnum] x_coord x coordinate in the map
		# @param [Fixnum] y_coord y coordinate in the map
		# @return [true|false]
		def crate?(x_coord, y_coord)
			box = what_is_on(x_coord, y_coord)
			box == CRATE or box == CRATE_ON_STORAGE
		end
		
		def crate_up?
			crate?(@man.x, @man.y-1)
		end
		
		def crate_two_steps_up?
			crate?(@man.x, @man.y-2)
		end
		
		def crate_down?
			crate?(@man.x, @man.y+1)
		end
		
		def crate_two_steps_down?
			crate?(@man.x, @man.y+2)
		end
		
		def crate_left?
			crate?(@man.x-1, @man.y)
		end
		
		def crate_two_steps_left?
			crate?(@man.x-2, @man.y)
		end
		
		def crate_right?
			crate?(@man.x+1, @man.y)
		end
		
		def crate_two_steps_right?
			crate?(@man.x+2, @man.y)
		end
		
		# Draw the man for map output
		def draw_man
			box = what_is_on @man.x, @man.y
			put_man_in_map if box == FLOOR
			put_man_on_storage_in_map if box == STORAGE
		end
		
		def put_man_in_map
			@map[@man.y][@man.x] = MAN
		end
		
		def put_man_on_storage_in_map
			@map[@man.y][@man.x] = MAN_ON_STORAGE
		end
		
		# Draw the crates for map output
		def draw_crates
			@crates.each {|crate| @map[crate.y][crate.x] = what_is_on(crate.x, crate.y) }
		end
		
		# Draw the storages location for map output
		def draw_storages
			@storages.each {|st| @map[st.y][st.x] = what_is_on(st.x, st.y) }
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
		
		# Removes all storages locations, all crates and the man, leaving only walls and floor.
		#
		# @param [Map] map 
		# @return [Map] map with only walls and floor
		def init_floor map
			floor = []
			map.each {|row| floor.push row.tr("#{STORAGE}#{CRATE}#{MAN}#{CRATE_ON_STORAGE}", FLOOR) }
			floor
		end
		
		# Find the man's position, at the begining of the level.
		#
		# @param [Map] map
		# @return [Man] an initialised man
		def init_man map
			x_coord = y_coord = 0
			map.each {|row| 
				if row.include?(MAN)
					x_coord = row.index(MAN)
					break
				end
				y_coord += 1
			}
			Man.new x_coord, y_coord
		end
		
		# Find position of crates and storages, at the begining of the level.
		#
		# @param [Map] map
		def init_crates_and_storages map
			y_coord = 0
			map.each do |line| 
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
