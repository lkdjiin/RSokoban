class TC_Skin < Test::Unit::TestCase
	include RSokoban
	
	def setup
		$RSOKOBAN_PATH = File.expand_path(File.dirname(__FILE__) + '/../..')
	end
	
	def test_list_all_skins
		list = UI::Skin.new.list_skins
		["Sokodroid", "BlueGranite"].each do |item|
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

end
