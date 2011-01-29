class TC_Game < Test::Unit::TestCase

	def setup
		$RSOKOBAN_DATA_PATH = File.expand_path(File.dirname(__FILE__))
		@game = RSokoban::Game.new :portable, 'original.xsb'
		# Make Game@ui nil to not start the ui.
		@game.instance_variable_set(:@ui, nil)
		# Load the first level, without starting ui (see previous line)
		@game.start_level
	end
	
	def test_level_width
		assert_equal 19, @game.level_width
	end
	
	def test_level_height
		assert_equal 11, @game.level_height
	end
	
	def test_level_title
		assert_equal '1', @game.level_title
	end
	
	def test_man_x
		assert_equal 11, @game.man_x
	end
	
end
