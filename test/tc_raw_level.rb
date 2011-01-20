
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
               
	def test_picture_accessors
		ins = RSokoban::RawLevel.new
		ins.picture = Picture1
		assert_equal Picture1, ins.picture
	end
	
	def test_default_picture
		ins = RSokoban::RawLevel.new
		assert_equal [], ins.picture
	end
	
end
