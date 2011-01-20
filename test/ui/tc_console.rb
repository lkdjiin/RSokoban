class TC_Console < Test::Unit::TestCase

	def setup
		@console = RSokoban::UI::Console.new
		# Console#parse is private, make it public for testing purpose.
		def @console.public_parse(*args)
			parse(*args)
		end
	end
	
	def test_string_quit_must_returns_symbol_quit
		assert_equal :quit, @console.public_parse('quit')
	end
	
	def test_string_help_must_returns_symbol_help
		assert_equal :help, @console.public_parse('help')
	end
	
	def test_string_retry_must_returns_symbol_retry
		assert_equal :retry, @console.public_parse('retry')
	end
	
	def test_string_up_must_returns_symbol_up
		assert_equal :up, @console.public_parse('up')
	end
	
	def test_string_down_must_returns_symbol_down
		assert_equal :down, @console.public_parse('down')
	end
	
	def test_string_right_must_returns_symbol_right
		assert_equal :right, @console.public_parse('right')
	end
	
	def test_string_left_must_returns_symbol_left
		assert_equal :left, @console.public_parse('left')
	end
	
	def test_string_z_must_returns_symbol_up
		assert_equal :up, @console.public_parse('z')
	end
	
	def test_string_s_must_returns_symbol_down
		assert_equal :down, @console.public_parse('s')
	end
	
	def test_string_q_must_returns_symbol_left
		assert_equal :left, @console.public_parse('q')
	end
	
	def test_string_d_must_returns_symbol_right
		assert_equal :right, @console.public_parse('d')
	end
	
	def test_string_representing_a_number_must_returns_this_number
		assert_equal 12, @console.public_parse("12")
	end
	
	def test_must_return_nil_if_number_is_negative
		assert_equal nil, @console.public_parse("-12")
	end
	
	def test_must_return_nil_if_number_is_zero
		assert_equal nil, @console.public_parse("0")
	end
	
	def test_xsb_filename_must_returns_itself
		assert_equal 'some_levels.xsb', @console.public_parse("some_levels.xsb")
	end
	
	def test_anything_else_must_returns_nil
		assert_equal nil, @console.public_parse('azerty')
	end
end
