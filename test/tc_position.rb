
class TC_Position < Test::Unit::TestCase

	def testInstance
		pos = RSokoban::Position.new
		assert_equal true, pos.instance_of?(RSokoban::Position)
	end

	def testXYForDefaultPositions
		pos = RSokoban::Position.new
		assert_equal 0, pos.x
		assert_equal 0, pos.y
	end
	
	def testXY
		pos = RSokoban::Position.new 12, 3
		assert_equal 12, pos.x
		assert_equal 3, pos.y
	end
	
	def testEqualityForDefaultPositions
		pos1 = RSokoban::Position.new
		pos2 = RSokoban::Position.new
		assert pos1 == pos2
	end
	
	def testEqlForDefaultPositions
		pos1 = RSokoban::Position.new
		pos2 = RSokoban::Position.new
		assert pos1.eql?(pos2)
	end
	
	def testEqualityForTwoDifferentPositions
		pos1 = RSokoban::Position.new 
		pos2 = RSokoban::Position.new 0, 1
		assert_equal false, pos1 == pos2
	end
	
	def testEquality
		pos1 = RSokoban::Position.new 1, 2
		pos2 = RSokoban::Position.new 1, 2
		assert pos1 == pos2
	end
	
	def testEqualityWithWrongObject
		pos1 = RSokoban::Position.new 
		pos2 = Object.new
		assert_equal false, pos1 == pos2
	end
	
	def testEqlForTwoDifferentPositions
		pos1 = RSokoban::Position.new 
		pos2 = RSokoban::Position.new 0, 1
		assert_equal false, pos1.eql?(pos2)
	end
	
	def testEql
		pos1 = RSokoban::Position.new 1, 2
		pos2 = RSokoban::Position.new 1, 2
		assert pos1.eql?(pos2)
	end
	
	def testEqlWithWrongObject
		pos1 = RSokoban::Position.new 
		pos2 = Object.new
		assert_equal false, pos1.eql?(pos2)
	end
	
	def testNotEqual
		pos1 = RSokoban::Position.new 11, 12
		pos2 = RSokoban::Position.new 1, 2
		assert pos1 != pos2
	end
	
end
