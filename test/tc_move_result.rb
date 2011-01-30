class TC_MoveResult < Test::Unit::TestCase
	
	def setup
		@res_ok = RSokoban::MoveResult.new(:status => :ok, :move_number => 123)
		@res_win = RSokoban::MoveResult.new(:status => :win, :move_number => 456)
		@res_err = RSokoban::MoveResult.new(:status => :error, :message => 'wall')
	end
	
	def test_status_ok
		assert_equal :ok, @res_ok[:status]
	end
	
	def test_question_ok
		assert_equal true, @res_ok.ok?
	end
	
	def test_move_number_ok
		assert_equal 123, @res_ok[:move_number]
	end
	
	def test_status_win
		assert_equal :win, @res_win[:status]
	end
	
	def test_question_win
		assert_equal true, @res_win.win?
	end
	
	def test_move_number_win
		assert_equal 456, @res_win[:move_number]
	end
	
	def test_status_error
		assert_equal :error, @res_err[:status]
	end
	
	def test_question_error
		assert_equal true, @res_err.error?
	end
	
	def test_message
		assert_equal 'wall', @res_err[:message]
	end
	
end
