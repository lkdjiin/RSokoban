class TC_Map < Test::Unit::TestCase

	def setup
		@map = RSokoban::Map.new
	end
	
	def test_default_picture_is_empy
		assert_equal [], RSokoban::Map.new.rows
	end
	
	def test_assigning_rows
		@map.rows = ['###', '# #', '###']
		assert_equal ['###', '# #', '###'], @map.rows
	end
	
	def test_get_height
		@map.rows = ['###', '# #', '###']
		assert_equal 3, @map.height
	end
	
	def test_get_width
		@map.rows = ['###', '####', '##']
		assert_equal 4, @map.width
	end
	
	def test_get_a_row
		@map.rows = ['###', '# #', '###']
		assert_equal '# #', @map[1]
	end
	
	def test_each_row
		@map.rows = ['#', '##', '###']
		expected = '#'
		@map.each {|row|
			assert_equal expected, row
			expected += '#'
		}
	end
	
end
