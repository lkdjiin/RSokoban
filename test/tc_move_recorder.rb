class TC_MoveRecorder < Test::Unit::TestCase

	def setup
		@mr = RSokoban::MoveRecorder.new
		
		# For testing purpose, add a method to reset the queue of moves.
		def @mr.empty_for_testing
			@queue = []
		end
		
		# For testing purpose, add a method to fill the queue of moves with known values.
		def @mr.fill_for_testing list
			@queue = list
		end
		
		# For testing purpose, add a method to get the queue of moves.
		def @mr.get_for_testing
			@queue
		end
	end
	
	def test_create_instance
		assert @mr.instance_of?(RSokoban::MoveRecorder)
	end
	
	def test_raise_exception_if_we_undo_an_empty_queue
		@mr.empty_for_testing
		assert_raise(RSokoban::EmptyMoveQueueError) do
			@mr.undo
		end
	end
	
	def test_record_up
		@mr.empty_for_testing
		@mr.record :up
		assert_equal [:up], @mr.get_for_testing
	end
	
	def test_record_down
		@mr.empty_for_testing
		@mr.record :down
		assert_equal [:down], @mr.get_for_testing
	end
	
	def test_record_left
		@mr.empty_for_testing
		@mr.record :left
		assert_equal [:left], @mr.get_for_testing
	end
	
	def test_record_right
		@mr.empty_for_testing
		@mr.record :right
		assert_equal [:right], @mr.get_for_testing
	end
	
	
	def test_record_up_and_push
		@mr.empty_for_testing
		@mr.record :up, :push
		assert_equal [:UP], @mr.get_for_testing
	end
	
	def test_record_down_and_push
		@mr.empty_for_testing
		@mr.record :down, :push
		assert_equal [:DOWN], @mr.get_for_testing
	end
	
	def test_record_left_and_push
		@mr.empty_for_testing
		@mr.record :left, :push
		assert_equal [:LEFT], @mr.get_for_testing
	end
	
	def test_record_right_and_push
		@mr.empty_for_testing
		@mr.record :right, :push
		assert_equal [:RIGHT], @mr.get_for_testing
	end
	
	
	def test_record_nothing_else_than_direction
		assert_raise(ArgumentError) do
			@mr.record :north
		end
	end
	
	def test_undo_give_the_last_move
		@mr.fill_for_testing [:up, :up, :left]
		assert_equal :left, @mr.undo
	end
	
	def test_undo_diminish_the_queue
		@mr.fill_for_testing [:up, :up, :left]
		@mr.undo
		assert_equal [:up, :up], @mr.get_for_testing
	end
	
end
