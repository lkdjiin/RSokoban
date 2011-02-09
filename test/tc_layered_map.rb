class TC_LayeredMap < Test::Unit::TestCase
	include RSokoban

	MAP_1 = [ '####',
	          '#..#',
	          '#$$#',
	          '#@ #',
	          '####']
	
	FLOOR_1 = [ '####',
	          '#  #',
	          '#  #',
	          '#  #',
	          '####']
	def setup
		map = Map.new MAP_1
		@lay_map = LayeredMap.new(map)
	end
	
	def test_must_be_initialized_from_map_or_array_of_string
		assert_raise(ArgumentError) do
			@lay_map = LayeredMap.new('a string')
		end
	end
	
	def test_floor
		assert_equal FLOOR_1, @lay_map.floor
	end
	
	def test_man_position
		man = @lay_map.man
		assert_equal 1, man.x
		assert_equal 3, man.y
	end
	
	def test_storages_positions
		store = Storage.new(1, 1)
		assert_equal true, @lay_map.storages.include?(store)
		
		store = Storage.new(2, 1)
		assert_equal true, @lay_map.storages.include?(store)
	end
	
	def test_crates_position
		crate = Crate.new(1, 2)
		assert_equal true, @lay_map.crates.include?(crate)
		
		crate = Crate.new(2, 2)
		assert_equal true, @lay_map.crates.include?(crate)
	end
	
	def test_map_as_array
		assert_equal MAP_1, @lay_map.map_as_array
	end
	
	def test_expected_wall
		assert_equal WALL, @lay_map.what_is_on(0, 0)
	end
	
	def test_expected_floor
		assert_equal FLOOR, @lay_map.what_is_on(2, 3)
	end
	
	def test_expected_crate
		assert_equal CRATE, @lay_map.what_is_on(1, 2)
	end
	
	def test_expected_storage
		assert_equal STORAGE, @lay_map.what_is_on(1, 1)
	end
	
end
