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
		# @param [RawLevel] rawLevel
		def initialize rawLevel
			@title = rawLevel.title
			init_dimension rawLevel.map
			@floor = init_floor rawLevel.map
			@man = init_man rawLevel.map
			@crates = []
			@storages = []
			init_crates_and_storages rawLevel.map
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
		def map
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
				i = @crates.index(Crate.new(@man.x, @man.y))
				@crates[i].send(direction)
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
					i = @crates.index(Crate.new(@man.x, @man.y))
					@crates[i].send(direction)
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
			@crates.each {|c|
				return false unless @storages.include?(c)
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
					near = crate?(@man.x, @man.y-1)
					boxBehind = what_is_on(@man.x, @man.y-2)
				when :down
					near = crate?(@man.x, @man.y+1)
					boxBehind = what_is_on(@man.x, @man.y+2)
				when :left
					near = crate?(@man.x-1, @man.y)
					boxBehind = what_is_on(@man.x-2, @man.y)
				when :right
					near = crate?(@man.x+1, @man.y)
					boxBehind = what_is_on(@man.x+2, @man.y)
			end
			return(near and boxBehind == WALL)
		end
		
		# Is there a crate followed by a crate near the man, in the direction pointed to by +direction+ ?
		# @param [:up|:down|:left|:right] direction
		# @return [true|nil]
		def double_crate?(direction)
			case direction
				when :up
					true if crate?(@man.x, @man.y-1) and crate?(@man.x, @man.y-2)
				when :down
					true if crate?(@man.x, @man.y+1) and crate?(@man.x, @man.y+2)
				when :left
					true if crate?(@man.x-1, @man.y) and crate?(@man.x-2, @man.y)
				when :right
					true if crate?(@man.x+1, @man.y) and crate?(@man.x+2, @man.y)
			end
		end
		
		# Is there a crate ('o' or '*') in the box pointed to by x, y ?
		# @param [Fixnum] x x coordinate in the map
		# @param [Fixnum] y y coordinate in the map
		# @return [true|false]
		def crate?(x, y)
			box = what_is_on(x, y)
			box == CRATE or box == CRATE_ON_STORAGE
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

		# Get the content of box x, y
		# @param [Fixnum] x x coordinate in the map
		# @param [Fixnum] y y coordinate in the map
		# @return [' ' | '#' | '.' | 'o' | '*']
		def what_is_on x, y
			box = (@floor[y][x]).chr
			if box == FLOOR
				s = Storage.new(x, y)
				c = Crate.new(x, y)
				if @storages.include?(s) and @crates.include?(c)
					box = CRATE_ON_STORAGE 
				elsif @storages.include?(s)
					box = STORAGE
				elsif @crates.include?(c)
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
			map.each {|x| floor.push x.tr("#{STORAGE}#{CRATE}#{MAN}#{CRATE_ON_STORAGE}", FLOOR) }
			floor
		end
		
		# Initialize map width and map height of this level
		def init_dimension map
			@width = 0
			map.each {|y| @width = y.size if y.size > @width }
			@height = map.size
		end
		
		# Find the man's position, at the begining of the level.
		#
		# @param [Map] map
		# @return [Man] an initialised man
		def init_man map
			x = y = 0
			map.each {|line| 
				if line.include?(MAN)
					x = line.index(MAN)
					break
				end
				y += 1
			}
			Man.new x, y
		end
		
		# Find position of crates and storages, at the begining of the level.
		#
		# @param [Map] map
		def init_crates_and_storages map
			y = 0
			map.each do |line| 
				count = 0
				line.each_char do |c| 
					@crates.push Crate.new(count, y) if c == CRATE
					@storages.push Storage.new(count, y) if c == STORAGE
					if c == CRATE_ON_STORAGE
						@crates.push Crate.new(count, y)
						@storages.push Storage.new(count, y)
					end
					count += 1
				end
				y += 1
			end
		end
		
	end

end
