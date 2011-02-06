class TC_GameFactory < Test::Unit::TestCase
	include RSokoban
	
	def test_create_a_game_ui
		game = GameFactory.create GamePortable
		assert_equal GamePortable, game.class
	end
	
	#~ def test_create_a_game_gui
		#~ game = GameFactory.create GameGUI
		#~ assert_equal GameGUI, game.class
	#~ end
	#~ 
	def test_create_with_wrong_argument
		assert_raise(ArgumentError) do
			game = GameFactory.create String
		end
	end
	
	def test_method_new_not_allowed
		assert_raise(NoMethodError) do
			gf = GameFactory.new
		end
	end

end
