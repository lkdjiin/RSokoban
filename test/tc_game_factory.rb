class TC_GameFactory < Test::Unit::TestCase
	include RSokoban
	
	def setup
		$RSOKOBAN_DATA_PATH = File.expand_path(File.dirname(__FILE__))
		@level_set_name = 'original.xsb'
	end
	
	def test_create_with_wrong_argument
		assert_raise(ArgumentError) do
			game = GameFactory.create String
		end
	end
	
	def test_method_new_is_not_allowed
		assert_raise(NoMethodError) do
			gf = GameFactory.new
		end
	end
	
	def test_create_a_game_with_portable_ui
		game = GameFactory.create(GamePortable, 'Fake UI', @level_set_name)
		assert_equal GamePortable, game.class
	end
	
	def test_create_a_game_with_curses_ui
		game = GameFactory.create(GameCurses, 'Fake UI', @level_set_name)
		assert_equal GameCurses, game.class
	end
	
	def test_create_a_game_with_tk_gui
		# tk is normally requiered from the bin/rsokoban program.
		require 'tk'
		game = GameFactory.create(GameTk, 'Fake UI', @level_set_name)
		assert_equal GameTk, game.class
	end
	
	

end
