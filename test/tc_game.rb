class TC_Game < Test::Unit::TestCase
	include RSokoban
	
	class GameFake
		include RSokoban::Game
	end
	
	def setup
		$RSOKOBAN_DATA_PATH = File.expand_path(File.dirname(__FILE__))
		@level_set_name = 'original.xsb'
		@game = GameFake.new('Fake UI', @level_set_name)
	end
	
	def test_game_is_not_instanciable
		assert_raise(NoMethodError) do
			ins = Game.new
		end
	end
	
	def test_run_method_must_failed
		assert_raise(NotImplementedError) do
			@game.run
		end
	end
	
	def test_start_level_method_must_failed
		assert_raise(NotImplementedError) do
			@game.start_level
		end
	end
	
	# must create a fake config file to test this
	#~ def test_level_number_is_initialized_to_1
		#~ assert_equal 1, @game.level_number
	#~ end
	
end
