class TC_PlayerAction < Test::Unit::TestCase
	
	def setup
		@pa = RSokoban::UI::PlayerAction.new
	end
	
	def test_default_action_is_nil
		assert_equal nil, RSokoban::UI::PlayerAction.new.action
	end

	def test_set_action_quit
		@pa.action = :quit
		assert_equal :quit, @pa.action
	end
	
	def test_set_action_along_constructor
		pa = RSokoban::UI::PlayerAction.new(:quit)
		assert_equal :quit, pa.action
	end
	
	def test_set_action_next
		@pa.action = :next
		assert_equal :next, @pa.action
	end
	
	def test_set_action_retry
		@pa.action = :retry
		assert_equal :retry, @pa.action
	end
	
	def test_set_action_undo
		@pa.action = :undo
		assert_equal :undo, @pa.action
	end
	
	def test_set_action_up
		@pa.action = :up
		assert_equal :up, @pa.action
	end
	
	def test_set_action_down
		@pa.action = :down
		assert_equal :down, @pa.action
	end
	
	def test_set_action_left
		@pa.action = :left
		assert_equal :left, @pa.action
	end
	
	def test_set_action_right
		@pa.action = :right
		assert_equal :right, @pa.action
	end
	
	def test_no_other_symbols_allowed
		assert_raise(ArgumentError) do
			@pa.action = :not_allowed
		end
	end
	
	def test_action_is_a_level_number
		@pa.action = 23
		assert_equal 23, @pa.action
	end
	
	def test_action_is_an_xsb_filename
		@pa.action = 'file.xsb'
		assert_equal 'file.xsb', @pa.action
	end
	
	def test_bad_filename
		assert_raise(ArgumentError) do
			@pa.action = 'file.x'
		end
	end
	
	def test_is_level_number
		@pa.action = 23
		assert_equal true, @pa.level_number?
	end
	
	def test_is_not_level_number
		@pa.action = :quit
		assert_equal false, @pa.level_number?
	end
	
	def test_is_set_name
		@pa.action = 'file.xsb'
		assert_equal true, @pa.set_name?
	end
	
	def test_is_not_set_name
		@pa.action = :quit
		assert_equal false, @pa.set_name?
	end
	
	def test_is_quit
		@pa.action = :quit
		assert_equal true, @pa.quit?
	end
	
	def test_is_not_quit
		@pa.action = :up
		assert_equal false, @pa.quit?
	end
	
	def test_is_next
		@pa.action = :next
		assert_equal true, @pa.next?
	end
	
	def test_is_not_next
		@pa.action = :up
		assert_equal false, @pa.next?
	end
	
	def test_is_retry
		@pa.action = :retry
		assert_equal true, @pa.retry?
	end
	
	def test_is_not_retry
		@pa.action = :up
		assert_equal false, @pa.retry?
	end
	
	def test_is_move
		@pa.action = :up
		assert_equal true, @pa.move?
		
		@pa.action = :down
		assert_equal true, @pa.move?
		
		@pa.action = :left
		assert_equal true, @pa.move?
		
		@pa.action = :right
		assert_equal true, @pa.move?
	end
	
	def test_is_not_move
		@pa.action = :quit
		assert_equal false, @pa.move?
	end
	
	def test_is_undo
		@pa.action = :undo
		assert_equal true, @pa.undo?
	end
	
	def test_is_not_undo
		@pa.action = :up
		assert_equal false, @pa.undo?
	end
end
