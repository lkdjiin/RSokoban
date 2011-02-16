class TC_Skin < Test::Unit::TestCase
	include RSokoban
	
	def setup
		$RSOKOBAN_PATH = File.expand_path(File.dirname(__FILE__) + '/../..')
	end
	
	def test_list_all_skins
		list = UI::Skin.new.list_skins
		["Sokodroid", "default"].each do |item|
			assert list.include? item
		end
	end
	
	def test_get_path_of_a_skin_dir
		sk = UI::Skin.new
		expected = File.join($RSOKOBAN_PATH, 'skins', 'default')
		assert_equal expected, sk.path_of_skin('default')
	end
	
	def test_get_path_of_an_unexisting_dir
		sk = UI::Skin.new
		assert_raise(ArgumentError) do
			sk.path_of_skin('unknown')
		end
	end

end
