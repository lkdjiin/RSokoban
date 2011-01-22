
class TC_RawLevel < Test::Unit::TestCase

	def test_instance
		ins = RSokoban::RawLevel.new
		assert_equal true, ins.instance_of?(RSokoban::RawLevel)
	end

	def test_title_accessors
		ins = RSokoban::RawLevel.new
		ins.title = "Le titre"
		assert_equal "Le titre", ins.title
	end
	
	def test_default_title
		ins = RSokoban::RawLevel.new
		assert_equal 'Unknown level title', ins.title
	end
	
	Picture1 = [ '#####',
               '#.$@#',
               '#####']
               
	def test_map_accessors
		ins = RSokoban::RawLevel.new
		ins.map = Picture1
		assert_equal Picture1, ins.map.rows
	end
	
	def test_default_map
		ins = RSokoban::RawLevel.new
		assert_equal RSokoban::Map.new, ins.map
	end
	
end
