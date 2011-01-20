require "../lib/rsokoban/moveable"

class TC_Moveable < Test::Unit::TestCase

	class Foo
		include RSokoban::Moveable
		attr_reader :x, :y
		def initialize
			@x = 12
			@y = 3
		end
	end
	
	def testUp
		pos = Foo.new
		pos.up
		assert_equal 12, pos.x
		assert_equal 2, pos.y
	end
	
	def testDown
		pos = Foo.new
		pos.down
		assert_equal 12, pos.x
		assert_equal 4, pos.y
	end
	
	def testLeft
		pos = Foo.new
		pos.left
		assert_equal 11, pos.x
		assert_equal 3, pos.y
	end
	
	def testRight
		pos = Foo.new
		pos.right
		assert_equal 13, pos.x
		assert_equal 3, pos.y
	end
end
