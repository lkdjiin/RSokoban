
class TC_LevelSet < Test::Unit::TestCase

	def test_instance
		ins = RSokoban::LevelSet.new
		assert_equal true, ins.instance_of?(RSokoban::LevelSet)
	end
	
	def test_title_accessors
		ins = RSokoban::LevelSet.new
		ins.title = "Le titre"
		assert_equal "Le titre", ins.title
	end
	
	def test_default_title
		ins = RSokoban::LevelSet.new
		assert_equal 'Unknown set title', ins.title
	end
	
	def test_description_accessors
		ins = RSokoban::LevelSet.new
		ins.description = "description"
		assert_equal "description", ins.description
	end
	
	def test_default_description
		ins = RSokoban::LevelSet.new
		assert_equal 'Empty description', ins.description
	end
	
	def test_raw_levels_list_accessors
		ins = RSokoban::LevelSet.new
		list = [].push(RSokoban::RawLevel.new('title', ['###']))
		ins.rawLevels = list
		assert_equal list, ins.rawLevels
	end
	
	def test_default_raw_levels_list
		ins = RSokoban::LevelSet.new
		assert_equal [], ins.rawLevels
	end
end
