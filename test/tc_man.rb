
class TC_Man < Test::Unit::TestCase

	def testInstance
		ins = RSokoban::Man.new 12, 3
		assert_equal true, ins.instance_of?(RSokoban::Man)
	end

	def testXY
		ins = RSokoban::Man.new 12, 3
		assert_equal 12, ins.x
		assert_equal 3, ins.y
	end
	
	def testUp
		pos = RSokoban::Man.new 12, 3
		pos.up
		assert_equal 12, pos.x
		assert_equal 2, pos.y
	end
	
	def testDown
		pos = RSokoban::Man.new 12, 3
		pos.down
		assert_equal 12, pos.x
		assert_equal 4, pos.y
	end
	
	def testLeft
		pos = RSokoban::Man.new 12, 3
		pos.left
		assert_equal 11, pos.x
		assert_equal 3, pos.y
	end
	
	def testRight
		pos = RSokoban::Man.new 12, 3
		pos.right
		assert_equal 13, pos.x
		assert_equal 3, pos.y
	end
	
	def testEqual
		pos1 = RSokoban::Man.new 99, 98
		pos2 = RSokoban::Man.new 99, 98
		assert pos1 == pos2
	end
	
	def testNotEqual
		pos1 = RSokoban::Man.new 99, 98
		pos2 = RSokoban::Man.new 19, 18
		assert pos1 != pos2
	end
	
end
