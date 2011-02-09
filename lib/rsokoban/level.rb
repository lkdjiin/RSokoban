module RSokoban

	# I am a level of the game.
	class Level
		attr_reader :title
		
		# Get map width of this level, in cells
		# @return [Fixnum]
		attr_reader :width
		
		# Get map height of this level, in cells
		# @return [Fixnum]
		attr_reader :height
		
		# I build the level from a RawLevel object.
		# @param [RawLevel] raw_level A RawLevel object, containing a title and a map.
		def initialize raw_level
			@title = raw_level.title
			@width = raw_level.map.width
			@height = raw_level.map.height
			@layered_map = LayeredMap.new raw_level.map
			@move = 0
			@map = nil
			@move_recorder = MoveRecorder.new
		end
		
		def storages
			@layered_map.storages
		end
		
		def floor
			@layered_map.floor
		end
		
		def man
			@layered_map.man
		end
		
		def crates
			@layered_map.crates
		end
		
		# Two Level objects are equals if their @title, @floor, @layered_map.man, @layered_map.crates and @layered_map.storages are equals.
		# @param [Object] obj
		# @return [false|true]
		def ==(obj)
			return false unless obj.kind_of?(Level)
			@layered_map.floor == obj.floor and @layered_map.man == obj.man and @layered_map.crates == obj.crates and @layered_map.storages == obj.storages and @title == obj.title
		end
		
		# Synonym of #==
		# @see #==
		def eql?(obj)
			self == obj
		end
		
		# Get an instant map of the game.
		# @return [Map] the map, after X turns of game.
		def map_as_array
			@layered_map.map_as_array
		end
		
		# Move the man one box +direction+.
		# @param [:up|:down|:right|:left] direction
		# @return [MoveResult] the move's result
		def move direction
			return MoveResult.new(:status => :error, :message => 'wall') if wall?(direction)
			return MoveResult.new(:status => :error, :message => 'wall behind crate') if wall_behind_crate?(direction)
			return MoveResult.new(:status => :error, :message => 'double crate') if double_crate?(direction)
			@move += 1
			@layered_map.man.send(direction)
			if @layered_map.crates.include?(Crate.new(@layered_map.man.x, @layered_map.man.y))
				idx = @layered_map.crates.index(Crate.new(@layered_map.man.x, @layered_map.man.y))
				@layered_map.crates[idx].send(direction)
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
				@layered_map.man.send(direction)
				@move += 1
				if @layered_map.crates.include?(Crate.new(@layered_map.man.x, @layered_map.man.y))
					idx = @layered_map.crates.index(Crate.new(@layered_map.man.x, @layered_map.man.y))
					@layered_map.crates[idx].send(direction)
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
					when :up then @layered_map.man.down
					when :down then @layered_map.man.up
					when :left then @layered_map.man.right
					when :right then @layered_map.man.left
					when :UP
						idx = @layered_map.crates.index(Crate.new(@layered_map.man.x, @layered_map.man.y-1))
						@layered_map.crates[idx].down
						@layered_map.man.down
					when :DOWN
						idx = @layered_map.crates.index(Crate.new(@layered_map.man.x, @layered_map.man.y+1))
						@layered_map.crates[idx].up
						@layered_map.man.up
					when :LEFT
						idx = @layered_map.crates.index(Crate.new(@layered_map.man.x-1, @layered_map.man.y))
						@layered_map.crates[idx].right
						@layered_map.man.right
					when :RIGHT
						idx = @layered_map.crates.index(Crate.new(@layered_map.man.x+1, @layered_map.man.y))
						@layered_map.crates[idx].left
						@layered_map.man.left
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
			return false if @layered_map.crates.size == 0 # needed for testing purpose.
			@layered_map.crates.each {|crate|
				return false unless @layered_map.storages.include?(crate)
			}
			true
		end
		
		# Is there a wall near the man, in the direction pointed to by +direction+ ?
		# @param [:up|:down|:left|:right] direction
		# @return [true|false]
		def wall? direction
			case direction
				when :up
					box = @layered_map.what_is_on(@layered_map.man.x, @layered_map.man.y-1)
				when :down
					box = @layered_map.what_is_on(@layered_map.man.x, @layered_map.man.y+1)
				when :left
					box = @layered_map.what_is_on(@layered_map.man.x-1, @layered_map.man.y)
				when :right
					box = @layered_map.what_is_on(@layered_map.man.x+1, @layered_map.man.y)
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
					box_behind = @layered_map.what_is_on(@layered_map.man.x, @layered_map.man.y-2)
				when :down
					near = crate_down?
					box_behind = @layered_map.what_is_on(@layered_map.man.x, @layered_map.man.y+2)
				when :left
					near = crate_left?
					box_behind = @layered_map.what_is_on(@layered_map.man.x-2, @layered_map.man.y)
				when :right
					near = crate_right?
					box_behind = @layered_map.what_is_on(@layered_map.man.x+2, @layered_map.man.y)
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
			box = @layered_map.what_is_on(x_coord, y_coord)
			box == CRATE or box == CRATE_ON_STORAGE
		end
		
		def crate_up?
			crate?(@layered_map.man.x, @layered_map.man.y-1)
		end
		
		def crate_two_steps_up?
			crate?(@layered_map.man.x, @layered_map.man.y-2)
		end
		
		def crate_down?
			crate?(@layered_map.man.x, @layered_map.man.y+1)
		end
		
		def crate_two_steps_down?
			crate?(@layered_map.man.x, @layered_map.man.y+2)
		end
		
		def crate_left?
			crate?(@layered_map.man.x-1, @layered_map.man.y)
		end
		
		def crate_two_steps_left?
			crate?(@layered_map.man.x-2, @layered_map.man.y)
		end
		
		def crate_right?
			crate?(@layered_map.man.x+1, @layered_map.man.y)
		end
		
		def crate_two_steps_right?
			crate?(@layered_map.man.x+2, @layered_map.man.y)
		end
		
	end

end
