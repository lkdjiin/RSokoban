class TC_GameGUI < Test::Unit::TestCase
	include RSokoban
	
	class GameFake
		include RSokoban::GameGUI
	end
	
	class UIFake
	end
	
	def setup
		$RSOKOBAN_DATA_PATH = File.expand_path(File.dirname(__FILE__))
		@level_set_name = 'original.xsb'
		@ui = UIFake.new
		# initialize a game
		@game = GameFake.new(@ui, @level_set_name)
		@game.start_level
	end
	
	def test_game_ui_is_not_instanciable
		assert_raise(NoMethodError) do
			ins = GameGUI.new
		end
	end
	
end
