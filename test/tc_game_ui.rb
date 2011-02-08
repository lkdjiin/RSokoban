# @todo find something to test the run method
class TC_GameUI < Test::Unit::TestCase
	include RSokoban

	class GameFake
		include RSokoban::GameUI
	end
	
	class UIFake
		def get_action(hash)
			RSokoban::UI::PlayerAction.new :quit
		end
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
			ins = GameUI.new
		end
	end
	
	def test_start_level_must_return_an_action
		game = GameFake.new(@ui, @level_set_name)
		assert_equal UI::PlayerAction, game.start_level.class
	end
	
	def test_run_method_must_respond_to_the_quit_command
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		assert_equal true, game.run
	end
	
	### Test module Game trough module GameUI ####################################
	
	def test_level_width
		assert_equal 19, @game.level_width
	end
	
	def test_level_height
		assert_equal 11, @game.level_height
	end
	
	def test_level_title
		assert_equal '1', @game.level_title
	end
	
	def test_map_as_array_must_return_an_array
		assert_equal Array, @game.map_as_array.class
	end
	
	def test_man_x
		assert_equal 11, @game.man_x
	end
	
	def test_man_y
		assert_equal 8, @game.man_y
	end
	
	def test_move_must_return_move_result
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		assert_equal MoveResult, game.move(:up).class
	end
	
	def test_initial_move_number_must_be_zero
		assert_equal 0, @game.move_number
	end
	
	def test_move_number
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		game.move(:up)
		assert_equal 1, game.move_number
	end
	
	def test_undo_must_return_move_result
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		assert_equal MoveResult, game.undo.class
	end
	
	def test_redo_must_return_move_result
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		assert_equal MoveResult, game.undo.class
	end
	
	def test_title_of_the_set
		assert_equal 'Original & Extra', @game.set_title
	end
	
	def test_size_of_the_set
		assert_equal 90, @game.set_size
	end
	
	def test_next_level
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		game.next_level
		assert_equal 2, game.level_number
	end
	
	def test_load_level
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		game.load_level 3
		assert_equal 3, game.level_number
	end
	
	def test_restart_set
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		game.load_level 3
		game.restart_set
		assert_equal 1, game.level_number
	end
	
	def test_load_a_set_that_doesnt_exist
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		game.load_a_new_set 'doesnt_exist.xsb'
		# assert nothing has changed
		assert_equal 1, game.level_number
		assert_equal 'Original & Extra', game.set_title
	end
	
	def test_load_a_set_of_levels
		game = GameFake.new(@ui, @level_set_name)
		game.start_level
		game.load_a_new_set 'test_file2.xsb'
		assert_equal 1, game.level_number
		assert_equal 'another test file', game.set_title
	end
	
end
