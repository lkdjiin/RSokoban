module RSokoban

	# I can record the moves of a game and restitute them one by one, 
	# started from the last one. I am very usefull to implement an
	# undo feature.
	class MoveRecorder
	
		def initialize
			@queue = []
			@redo = []
		end
		
		# @return [:up, :down, :left, :right, :UP, :DOWN, :LEFT, :RIGHT]
		# @raise EmptyMoveQueueError
		# @since 0.73
		def undo
			raise EmptyMoveQueueError if @queue.empty?
			@redo << @queue.pop
			@redo[-1]
		end
		
		# @return [:up, :down, :left, :right, :UP, :DOWN, :LEFT, :RIGHT]
		# @raise EmptyRedoError
		# @since 0.74
		def redo
			raise EmptyRedoError if @redo.empty?
			@queue << @redo.pop
			@queue[-1]
		end
		
		# Record the move +direction+
		# @param [:up, :down, :left, :right] direction
		# @raise ArgumentError if +direction+ is not included in [:up, :down, :left, :right]
		# @since 0.73
		def record direction, push = nil
			raise ArgumentError unless [:up, :down, :left, :right].include?(direction)
			@redo = []
			if push
				@queue.push :UP if direction == :up
				@queue.push :DOWN if direction == :down
				@queue.push :LEFT if direction == :left
				@queue.push :RIGHT if direction == :right
			else
				@queue.push direction
			end
		end
		
	end

end
