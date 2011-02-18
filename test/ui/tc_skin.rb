class TC_Skin < Test::Unit::TestCase
	include RSokoban
	
	$RSOKOBAN_PATH = File.expand_path(File.dirname(__FILE__) + '/../..')
	
	BLUE_GRANITE_FILENAMES = { 
		:store => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'store.bmp'),
		:crate => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'crate.bmp'),
		:floor => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'floor.bmp'),
		:crate_store => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'crate_store.bmp'),
		:outside => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'outside.bmp'),
		:man_up => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'man_up.bmp'),
		:man_down => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'man_down.bmp'),
		:man_left => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'man_left.bmp'),
		:man_right => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'man_right.bmp'),
		:man_store_up => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'man_store_up.bmp'),
		:man_store_down => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'man_store_down.bmp'),
		:man_store_left => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'man_store_left.bmp'),
		:man_store_right => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'man_store_right.bmp'),
		:wall => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_d => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_dl => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_dlr => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_dr => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_l => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_lr => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_r => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_u => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_ud => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_udl => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_udlr => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_udr => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_ul => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_ulr => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp'),
		:wall_ur => File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite', 'wall.bmp')}
	
	def test_list_all_skins
		list = UI::Skin.new.list_skins
		# This is the list of skins provided with the program
		["Sokodroid", "BlueGranite", "HeavyMetal"].each do |item|
			assert list.include? item
		end
	end
	
	def test_get_path_of_a_skin_dir
		sk = UI::Skin.new
		expected = File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite')
		assert_equal expected, sk.path_of_skin('BlueGranite')
	end
	
	def test_get_path_of_an_unexisting_dir
		sk = UI::Skin.new
		assert_raise(ArgumentError) do
			sk.path_of_skin('unknown')
		end
	end
	
	def test_size_of_a_skin
		sk = UI::Skin.new
		full_path_dir = File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite')
		assert_equal 30, sk.size_of(full_path_dir)
	end
	
	def test_list_of_filename
		sk = UI::Skin.new
		full_path_dir = File.join($RSOKOBAN_PATH, 'skins', 'BlueGranite')
		filenames = sk.filenames full_path_dir
		assert_equal BLUE_GRANITE_FILENAMES, filenames
	end

end
